# 📚 Biblioteca de Módulos Terraform — TechNova (Aula 06)

Biblioteca de módulos reutilizables para provisionar ambientes completos
(dev + staging) de la TechNova con **una sola llamada de módulos**, usando
composición: el output de un módulo alimenta el input de otro.

## Arquitectura (diagrama de dependencias)

```text
        ┌───────────┐
        │    VPC    │  create VPC + subnets dinámicas (for_each) + IGW + route tables
        └─────┬─────┘
      ┌───────┼───────┐
      ▼       ▼       ▼
  Security  Security  Security
   Group     Group     Group
   (api)     (rds)     (bastion…)
      │         │
      ▼         ▼
    EC2        RDS        ── los outputs del SG también van al EC2/RDS
```

## Módulos disponibles

| Módulo | Descripción | Inputs principales | Outputs |
|--------|-------------|--------------------|---------|
| `modules/vpc` | VPC completa con subnets dinámicas (`for_each`), IGW y route tables | `vpc_cidr`, `project_name`, `environment`, `subnets` (map) | `vpc_id`, `public_subnet_ids`, `private_subnet_ids` |
| `modules/security-group` | SG genérico con reglas de entrada como lista de objetos | `name`, `vpc_id`, `ingress_rules`, `environment`, `project_name` | `sg_id` |
| `modules/ec2` | Instancia EC2 configurable (AMI, subnet, SGs, key, user_data) | `instance_name`, `instance_type`, `ami_id`, `subnet_id`, `security_group_ids`, `key_name` | `instance_id`, `public_ip`, `private_ip` |
| `modules/rds` | RDS PostgreSQL con DB Subnet Group | `db_name`, `db_username`, `db_password`, `subnet_ids`, `security_group_ids` | `db_endpoint`, `db_name`, `db_port` |

## Ambientes

| Ambiente | VPC CIDR | DB Name | Naming |
|----------|----------|---------|--------|
| `environments/dev` | `10.0.0.0/16` | `technova_dev` | `technova-dev-*` |
| `environments/staging` | `10.1.0.0/16` | `technova_staging` | `technova-staging-*` |

## Cómo usar

Para crear un nuevo ambiente, copia `environments/dev` y cambia las variables
en `variables.tf` / `terraform.tfvars` (CIDRs, nombres, claves).

### Validación local (sin aplicar nada)

```bash
cd environments/dev
terraform init
terraform validate
terraform plan
```

Repite para `environments/staging`.

> ⚠️ **No hagas `apply` sin necesitarlo.** El TF no lo exige y los recursos AWS
> tienen costo. Si haces `apply` para probar, ejecuta `terraform destroy` al final.

## Prerrequisitos

- AWS CLI configurado (`~/.aws/credentials`) **antes de `terraform plan`/`apply`**
- Terraform >= 1.3
- Key Pair existente en la región (indicado en `terraform.tfvars`)
- AMI válida en `terraform.tfvars` (la incluida es de ejemplo)

## Evidencias

Los outputs de `terraform plan` se guardan en:
`environments/<env>/terraform-plan-output.txt` (generados por Zenith).