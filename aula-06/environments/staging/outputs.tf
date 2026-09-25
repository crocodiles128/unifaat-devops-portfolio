output "vpc_id" {
  description = "ID da VPC"
  value       = module.vpc.vpc_id
}

output "api_server_id" {
  description = "ID da instância EC2 da API"
  value       = module.api_server.instance_id
}

output "api_public_ip" {
  description = "IP pública da instância da API"
  value       = module.api_server.public_ip
}

output "db_endpoint" {
  description = "Endpoint del RDS"
  value       = module.database.db_endpoint
}

output "db_name" {
  description = "Nome del database"
  value       = module.database.db_name
}

output "db_port" {
  description = "Puerto del database"
  value       = module.database.db_port
}