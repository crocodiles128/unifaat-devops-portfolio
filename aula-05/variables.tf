# variables.tf

variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto (usado em tags e nomes)"
  type        = string
  default     = "technova"
}

variable "vpc_cidr" {
  description = "CIDR block da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR da subnet pública (EC2)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidrs" {
  description = "CIDRs das 2 subnets privadas (RDS, AZs diferentes)"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "db_username" {
  description = "Username do banco de dados RDS"
  type        = string
  default     = "technova_admin"
}

variable "db_password" {
  description = "Password do banco de dados RDS (defina em terraform.tfvars)"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "technova"
}

variable "db_instance_class" {
  description = "Classe da instância RDS (Free Tier)"
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine_version" {
  description = "Versão do PostgreSQL"
  type        = string
  default     = "15"
}

variable "ec2_instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "ssh_public_key_path" {
  description = "Chave pública SSH usada no key pair do EC2"
  type        = string
  default     = "~/.ssh/technova-key.pub"
}

variable "allowed_ssh_cidr" {
  description = "CIDR liberado para SSH (restrinja ao seu IP em produção)"
  type        = string
  default     = "0.0.0.0/0"
}
