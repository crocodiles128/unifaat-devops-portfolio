output "db_endpoint" {
  description = "Endpoint del RDS (host)"
  value       = aws_db_instance.db.endpoint
}

output "db_name" {
  description = "Nome del database"
  value       = var.db_name
}

output "db_port" {
  description = "Puerto del database"
  value       = aws_db_instance.db.port
}