variable "instance_name" {
  type        = string
  description = "Nombre da instância (sólo el nombre)"
}

variable "instance_type" {
  type        = string
  description = "Tipo de instância (default: t2.micro)"
  default     = "t2.micro"
}

variable "ami_id" {
  type        = string
  description = "AMI ID a utilizar"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID onde será implantada la instância"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Lista de Security Group IDs"
}

variable "key_name" {
  type        = string
  description = "Nombre del Key Pair (existente na región)"
}

variable "user_data" {
  type        = string
  description = "Script opcional de user_data (base64 no requerido)"
  default     = null
}

variable "environment" {
  type        = string
  description = "Ambiente: dev, staging, prod"
}

variable "project_name" {
  type        = string
  description = "Nome do projeto (usado em tags e naming)"
}