variable "aws_region" {
  description = "Regiao AWS usada para o exercicio."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto usado nas tags e policies."
  type        = string
  default     = "TechNova"
}

variable "environment" {
  description = "Ambiente logico dos recursos."
  type        = string
  default     = "dev"
}

variable "aluno" {
  description = "Nome completo do aluno para tags obrigatorias."
  type        = string
  default     = "SEU NOME"
}

variable "ra" {
  description = "RA do aluno para tags obrigatorias."
  type        = string
  default     = "SEU-RA"
}

locals {
  name_prefix = "SEURA"

  common_tags = {
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Aluno       = var.aluno
    RA          = var.ra
    Disciplina  = "DevOps - UniFAAT 2026-2"
    Aula        = "03"
    Environment = var.environment
  }
}

