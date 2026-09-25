# TechNova — Aula 05: RDS + Remote State ([Lucas José Campos da Rocha])

Infraestrutura completa da TechNova com data layer gerenciado e state remoto.
Aluno: **[Lucas José Campos da Rocha]** — RA **6325123**.

## Arquitetura

```text
Internet
   |
   v
[ Internet Gateway ]
   |
   v
 VPC 10.0.0.0/16
 ├── subnet pública  10.0.1.0/24 (AZ-a) ── EC2 t2.micro (cliente psql, API 3000)
 ├── subnet privada  10.0.2.0/24 (AZ-a) ─┐
 └── subnet privada  10.0.4.0/24 (AZ-b) ─┴─ DB Subnet Group ── RDS PostgreSQL 15 (db.t3.micro)
```

State remoto: bucket S3 (versionamento + SSE + Block Public Access) e tabela
DynamoDB (`LockID`) — nada de `terraform.tfstate` no repositório.

## Arquivos

| Arquivo | Conteúdo |
|---------|----------|
| `providers.tf` | provider AWS + backend `s3` (remote state) |
| `variables.tf` | variáveis, incluindo `db_password` com `sensitive = true` |
| `vpc.tf` | VPC, 1 subnet pública, 2 privadas em AZs diferentes, IGW e route table |
| `rds.tf` | DB Subnet Group, SG do RDS (5432 só da VPC) e a instância PostgreSQL |
| `ec2.tf` | AMI, key pair, SG do EC2 (22/3000) e a instância t2.micro |
| `outputs.tf` | `rds_endpoint`, `ec2_public_ip`, `connection_string`, ... |
| `seed.sql` | tabela `orders` + dados para provar persistência |
| `backend/` | stack que cria o bucket S3 e a tabela DynamoDB do state |
| `scripts/capturar-evidencias.sh` | automatiza as evidências (aws s3 ls, psql, destroy) |

## 1. Backend remoto (primeiro!)

```bash
cd backend
terraform init
terraform apply          # cria bucket + tabela de lock
terraform output backend_config   # confira os nomes gerados
```

## 2. Stack principal

```bash
cp terraform.tfvars.example terraform.tfvars   # ajuste a senha (arquivo ignorado pelo git)
terraform init
terraform validate
terraform plan
terraform apply
```

## 3. Evidências

```bash
terraform output connection_string
terraform output ec2_ssh_command
bash scripts/capturar-evidencias.sh            # grava em evidencias/
```

## 4. Destroy (obrigatório antes do PR)

```bash
bash scripts/capturar-evidencias.sh --destruir
```

## Decisões de segurança

- `publicly_accessible = false` e `multi_az = false` no RDS (Free Tier).
- `storage_encrypted = true` e `skip_final_snapshot = true` (lab).
- SG do RDS libera a porta 5432 apenas para o CIDR da VPC.
- `db_password` marcada como `sensitive` e fora do Git (`terraform.tfvars`).
- Bucket do state: SSE habilitada, versionamento e os 4 bloqueios públicos.

## Checklist do TF

- [x] VPC 10.0.0.0/16 com 1 subnet pública + 2 privadas em AZs diferentes
- [x] Internet Gateway e route table associados à subnet pública
- [x] RDS PostgreSQL 15 `db.t3.micro`, 20 GB `gp2`, sem acesso público
- [x] EC2 `t2.micro` na subnet pública com cliente PostgreSQL
- [x] Security Groups: 5432 apenas da VPC; SSH/3000 no EC2
- [x] Remote state: bucket S3 + tabela DynamoDB (`LockID`)
- [x] Outputs úteis e tags em todos os recursos
- [x] `.gitignore` cobrindo `.terraform/`, `*.tfstate`, `terraform.tfvars`, `*.pem`

> Gerado e validado por **Zenith** (agente DevOps). Evidências de execução real
> ficam em `evidencias/` após rodar o script com credenciais AWS válidas.
