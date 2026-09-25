variable "aws_region" {
  type        = string
  description = "Región AWS donde se crean los recursos"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR da VPC (ambiente dev: 10.0.0.0/16)"
}

variable "subnets" {
  type = map(object({
    cidr = string
    az   = string
    type = string
  }))
  description = "Mapa de subnets del ambiente"
}

variable "project_name" {
  type        = string
  description = "Nome do projeto"
  default     = "technova"
}

variable "environment" {
  type        = string
  description = "Ambiente: dev o staging"
}

variable "ami_id" {
  type        = string
  description = "AMI ID a utilizar (valida antes de aplicar)"
}

variable "key_name" {
  type        = string
  description = "Key Pair name existente na região (valida antes de aplicar)"
}

variable "db_name" {
  type        = string
  description = "Nome do database RDS"
}

variable "db_username" {
  type        = string
  description = "Usuário master do RDS"
  default     = "technova_admin"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Password master do RDS"
}