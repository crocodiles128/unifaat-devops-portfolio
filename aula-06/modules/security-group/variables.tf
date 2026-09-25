variable "name" {
  type        = string
  description = "Nombre del Security Group (ej: api, rds, bastion)"
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC onde será criado o Security Group"
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), ["0.0.0.0/0"])
    description = optional(string, "")
  }))
  description = "Reglas de entrada como lista de objetos"
}

variable "environment" {
  type        = string
  description = "Ambiente: dev, staging, prod"
}

variable "project_name" {
  type        = string
  description = "Nome do projeto (usado em tags e naming)"
}