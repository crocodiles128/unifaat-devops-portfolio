variable "db_name" {
  type        = string
  description = "Nome do database"
}

variable "db_username" {
  type        = string
  description = "Usuário master do database"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Password master do database (alfanumérica, sem caracteres especiais problemáticos)"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs para o DB Subnet Group (privadas)"
}

variable "security_group_ids" {
  type        = list(string)
  description = "SG IDs para el RDS"
}

variable "instance_class" {
  type        = string
  description = "Classe da instância RDS (default: db.t3.micro)"
  default     = "db.t3.micro"
}

variable "environment" {
  type        = string
  description = "Ambiente: dev, staging, prod"
}

variable "project_name" {
  type        = string
  description = "Nome do projeto (usado em tags e naming)"
}