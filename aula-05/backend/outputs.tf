# backend/outputs.tf

output "state_bucket_name" {
  description = "Bucket S3 do Terraform state (usar no backend da stack principal)"
  value       = aws_s3_bucket.state.id
}

output "state_bucket_arn" {
  description = "ARN do bucket do state"
  value       = aws_s3_bucket.state.arn
}

output "lock_table_name" {
  description = "Tabela DynamoDB de lock (usar no backend da stack principal)"
  value       = aws_dynamodb_table.locks.name
}

output "backend_config" {
  description = "Bloco backend a colar em ../providers.tf"
  value = join("\n", [
    "backend \"s3\" {",
    "  bucket         = \"${aws_s3_bucket.state.id}\"",
    "  key            = \"aula-05/terraform.tfstate\"",
    "  region         = \"us-east-1\"",
    "  encrypt        = true",
    "  dynamodb_table = \"${aws_dynamodb_table.locks.name}\"",
    "}",
  ])
}
