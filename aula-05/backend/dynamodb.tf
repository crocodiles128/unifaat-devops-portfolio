# backend/dynamodb.tf — tabela de lock do state

resource "aws_dynamodb_table" "locks" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = var.lock_table_name
    Project = var.project_name
    Aula    = "05"
    Purpose = "Terraform State Locking"
  }
}
