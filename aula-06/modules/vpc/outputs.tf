output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR de la VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Lista de IDs das subnets públicas"
  value       = [for k, v in local.public_subnets : aws_subnet.this[k].id]
}

output "private_subnet_ids" {
  description = "Lista de IDs das subnets privadas"
  value       = [for k, v in local.private_subnets : aws_subnet.this[k].id]
}