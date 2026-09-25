# ──────────────────────────────────────────────────────────────
# Ambiente DEV — TechNova (aula-06)
# Demuestra la composición de módulos: output de un módulo se
# convierte en input de otro.
# ──────────────────────────────────────────────────────────────

module "vpc" {
  source       = "../../modules/vpc"
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  environment  = var.environment
  subnets      = var.subnets
}

module "api_sg" {
  source       = "../../modules/security-group"
  name         = "api"
  vpc_id       = module.vpc.vpc_id            # ← composição (VPC → SG)
  environment  = var.environment
  project_name = var.project_name
  ingress_rules = [
    { from_port = 22,    to_port = 22,    protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "SSH" },
    { from_port = 3000,  to_port = 3000,  protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "API" },
  ]
}

module "rds_sg" {
  source       = "../../modules/security-group"
  name         = "rds"
  vpc_id       = module.vpc.vpc_id            # ← composição (VPC → SG)
  environment  = var.environment
  project_name = var.project_name
  ingress_rules = [
    { from_port = 5432, to_port = 5432, protocol = "tcp", cidr_blocks = ["10.0.0.0/8"], description = "PostgreSQL" },
  ]
}

module "api_server" {
  source             = "../../modules/ec2"
  instance_name      = "api"
  instance_type      = "t2.micro"
  ami_id             = var.ami_id
  subnet_id          = module.vpc.public_subnet_ids[0]      # ← composição (VPC → EC2)
  security_group_ids = [module.api_sg.sg_id]                # ← composição (SG → EC2)
  key_name           = var.key_name
  environment        = var.environment
  project_name       = var.project_name
}

module "database" {
  source             = "../../modules/rds"
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  subnet_ids         = module.vpc.private_subnet_ids        # ← composição (VPC → RDS)
  security_group_ids = [module.rds_sg.sg_id]                # ← composição (SG → RDS)
  environment        = var.environment
  project_name       = var.project_name
}