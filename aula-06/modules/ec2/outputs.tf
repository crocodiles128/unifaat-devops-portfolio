output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "IP pública da instância"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "IP privada da instância"
  value       = aws_instance.this.private_ip
}