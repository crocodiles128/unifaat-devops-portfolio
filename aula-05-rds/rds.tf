# rds.tf

# DB Subnet Group - REQUER subnets em 2+ AZs diferentes
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name    = "${var.project_name}-db-subnet-group"
    Project = var.project_name
  }
}

# Security Group para RDS (adicionar ao rds.tf)
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Security Group para RDS - permite PostgreSQL apenas da VPC"
  vpc_id      = aws_vpc.main.id

  # Entrada: PostgreSQL (5432) apenas de dentro da VPC
  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Saída: nenhuma (RDS não precisa acessar internet)
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-rds-sg"
    Project = var.project_name
  }
}

# Instância RDS PostgreSQL (adicionar ao rds.tf)
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-db"

  # Engine
  engine         = "postgres"
  engine_version = "15"

  # Capacidade (Free Tier)
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  # Banco de dados
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  # Rede
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  # Alta disponibilidade (desligada para Free Tier)
  multi_az = false

  # Backup
  backup_retention_period = 7
  backup_window           = "03:00-04:00"

  # Manutenção
  maintenance_window = "sun:04:00-sun:05:00"

  # Encriptação
  storage_encrypted = true

  # Deletar sem snapshot final (para lab - NÃO faça isso em produção!)
  skip_final_snapshot = true

  # Performance Insights (desligado para Free Tier)
  performance_insights_enabled = false

  tags = {
    Name    = "${var.project_name}-rds"
    Project = var.project_name
    Aula    = "05"
  }
}