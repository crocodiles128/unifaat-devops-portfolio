# backend/variables.tf

variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto (tags)"
  type        = string
  default     = "technova"
}

variable "state_bucket_name" {
  description = "Nome do bucket S3 do state (deve casar com o backend em providers.tf)"
  type        = string
  default     = "technova-terraform-state-6325123"
}

variable "lock_table_name" {
  description = "Nome da tabela DynamoDB de lock (deve casar com o backend)"
  type        = string
  default     = "technova-terraform-locks"
}
