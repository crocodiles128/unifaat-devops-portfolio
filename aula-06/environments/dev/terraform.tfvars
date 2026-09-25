aws_region   = "us-east-1"
project_name = "technova"
environment  = "dev"

vpc_cidr = "10.0.0.0/16"
subnets = {
  "public-a"  = { cidr = "10.0.1.0/24", az = "us-east-1a", type = "public" }
  "public-b"  = { cidr = "10.0.2.0/24", az = "us-east-1b", type = "public" }
  "private-a" = { cidr = "10.0.3.0/24", az = "us-east-1a", type = "private" }
  "private-b" = { cidr = "10.0.4.0/24", az = "us-east-1b", type = "private" }
}

# ⚠️ Antes de `terraform apply`:
#   - reemplaza la AMI por una válida de tu región;
#   - crea el Key Pair con el nombre indicado o cámbialo.
ami_id   = "ami-057a54a7e9d69b9e4"   # Amazon Linux 2023 (x86_64, us-east-1) — ejemplo
key_name = "technova-key"            # ejemplo — debe existir en tu región

db_name     = "technova_dev"
db_username = "technova_admin"
db_password = "TechnovaDev12345"      # alfanumérica para evitar problemas con @ / " / etc.