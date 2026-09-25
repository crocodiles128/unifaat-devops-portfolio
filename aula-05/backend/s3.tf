# backend/s3.tf — bucket do Terraform state

resource "aws_s3_bucket" "state" {
  bucket = var.state_bucket_name

  # Lab: permite destruir mesmo com objetos dentro. Em produção: prevent_destroy
  force_destroy = true

  tags = {
    Name    = var.state_bucket_name
    Project = var.project_name
    Aula    = "05"
    Purpose = "Terraform Remote State"
  }
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encriptação server-side por padrão (AES256, sem custo de KMS)
resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block Public Access: os 4 bloqueios ativos
resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
