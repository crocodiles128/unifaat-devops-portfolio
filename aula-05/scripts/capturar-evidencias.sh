#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# capturar-evidencias.sh — Aula 05 (RDS + Remote State)
#
# Precisa de credenciais AWS válidas (Learner Lab). Captura:
#   evidencias/state-no-s3.txt     -> aws s3 ls do state
#   evidencias/conexao-psql.txt    -> psql do EC2 ao RDS (+ seed.sql)
#   evidencias/plan-limpo.txt      -> terraform plan (No changes)
#   evidencias/destroy.txt         -> terraform destroy (com --destruir)
#
# Uso:  bash scripts/capturar-evidencias.sh [--destruir]
# ──────────────────────────────────────────────────────────────
set -euo pipefail

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
EV="$RAIZ/evidencias"
BUCKET="technova-terraform-state-6325123"
CHAVE="${HOME}/.ssh/technova-key"
mkdir -p "$EV"

log() { printf '\n== %s ==\n' "$1"; }

log "Credenciais AWS"
aws sts get-caller-identity | tee "$EV/credenciais.txt"

log "1/6 Backend remoto (S3 + DynamoDB)"
terraform -chdir="$RAIZ/backend" init -input=false
terraform -chdir="$RAIZ/backend" apply -auto-approve -input=false

log "2/6 Stack principal (VPC + RDS + EC2)"
terraform -chdir="$RAIZ" init -input=false
terraform -chdir="$RAIZ" apply -auto-approve -input=false

log "3/6 Evidencia: state no S3"
aws s3 ls "s3://${BUCKET}/aula-05/" | tee "$EV/state-no-s3.txt"

log "4/6 Evidencia: plan limpo"
terraform -chdir="$RAIZ" plan -input=false -no-color | tee "$EV/plan-limpo.txt"

log "5/6 Evidencia: conexao EC2 -> RDS via psql"
IP="$(terraform -chdir="$RAIZ" output -raw ec2_public_ip)"
ENDERECO="$(terraform -chdir="$RAIZ" output -raw rds_address)"
tfvar() {
  grep -E "^[[:space:]]*$1" "$RAIZ/terraform.tfvars" | head -1 | cut -d'"' -f2
}
USUARIO="$(tfvar db_username)"; USUARIO="${USUARIO:-technova_admin}"
SENHA="$(tfvar db_password)"
BANCO="$(tfvar db_name)"; BANCO="${BANCO:-technova}"

{
  echo "ssh -i ${CHAVE} ec2-user@${IP}"
  echo "psql -h ${ENDERECO} -U ${USUARIO} -d ${BANCO} -p 5432"
  ssh -o StrictHostKeyChecking=accept-new -i "$CHAVE" "ec2-user@${IP}" \
    "PGPASSWORD='${SENHA}' psql -h ${ENDERECO} -U ${USUARIO} -d ${BANCO} -p 5432 -c 'SELECT version();'"
} | tee "$EV/conexao-psql.txt"

# Carrega o seed e comprova persistencia dos dados
scp -i "$CHAVE" "$RAIZ/seed.sql" "ec2-user@${IP}:/tmp/seed.sql"
ssh -i "$CHAVE" "ec2-user@${IP}" \
  "PGPASSWORD='${SENHA}' psql -h ${ENDERECO} -U ${USUARIO} -d ${BANCO} -p 5432 -f /tmp/seed.sql" \
  | tee -a "$EV/conexao-psql.txt"

if [[ "${1:-}" == "--destruir" ]]; then
  log "6/6 Destruindo tudo (obrigatorio antes do PR)"
  terraform -chdir="$RAIZ" destroy -auto-approve -input=false | tee "$EV/destroy.txt"
  aws s3 rm "s3://${BUCKET}" --recursive >> "$EV/destroy.txt" 2>&1 || true
  terraform -chdir="$RAIZ/backend" destroy -auto-approve -input=false \
    | tee -a "$EV/destroy.txt"
  echo "Destroy concluido; confira o console para nao deixar recursos."
else
  echo "Evidencias capturadas em $EV"
  echo "Depois de conferir, rode: bash scripts/capturar-evidencias.sh --destruir"
fi
