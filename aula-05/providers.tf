# ──────────────────────────────────────────────────────────────
# providers.tf — TechNova (aula-05): RDS + Remote State
# O state fica no S3 com lock no DynamoDB (nada de tfstate no repo).
# A stack ./backend cria o bucket e a tabela; aplique-a primeiro.
# Sem credenciais válidas, valide com: terraform init -backend=false
# ──────────────────────────────────────────────────────────────

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend remoto (S3 + DynamoDB). Os valores espelham ./backend.
  backend "s3" {
    bucket         = "technova-terraform-state-6325123"
    key            = "aula-05/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "technova-terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region

  # Tags em todos os recursos (Name continua explícito em cada um).
  default_tags {
    tags = {
      Project = var.project_name
      Aula    = "05"
      Owner   = "Lucas José Campos da Rocha"
    }
  }
}
