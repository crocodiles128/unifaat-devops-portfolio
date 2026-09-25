resource "aws_db_subnet_group" "db" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_db_instance" "db" {
  identifier              = "${var.project_name}-${var.environment}-db"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  instance_class          = var.instance_class
  engine                  = "postgres"
  engine_version          = "16"
  db_subnet_group_name    = aws_db_subnet_group.db.name
  vpc_security_group_ids  = var.security_group_ids
  skip_final_snapshot     = true
  allocated_storage       = 10
  storage_type            = "standard"
  backup_retention_period = 0

  tags = {
    Name        = "${var.project_name}-${var.environment}-db"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}