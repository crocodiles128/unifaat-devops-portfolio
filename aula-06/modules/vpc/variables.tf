variable "vpc_cidr" {
  type        = string
  description = "CIDR block de la VPC"
}

variable "project_name" {
  type        = string
  description = "Nome do projeto (usado em tags e naming)"
}

variable "environment" {
  type        = string
  description = "Ambiente: dev, staging, prod"
}

variable "subnets" {
  type = map(object({
    cidr = string
    az   = string
    type = string
  }))
  description = "Mapa de subnets: nombre -> { cidr, az, type: public|private }"
}