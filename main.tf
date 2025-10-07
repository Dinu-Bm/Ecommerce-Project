# VPC Module
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  environment        = var.environment
  availability_zones = var.availability_zones
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security_group"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}


# Create EC2 Key Pair
resource "aws_key_pair" "ecommerce" {
  key_name   = "ecommerce-key-2"
  public_key = file("C:/Users/dines/.ssh/id_rsa.pub")
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  environment      = var.environment
  vpc_id          = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.alb_sg_id
}

# Generate random password for DB if not provided
resource "random_password" "db_password" {
  length  = 16
  special = false
}

# RDS Module
module "rds" {
  source = "./modules/rds"

  environment        = var.environment
  instance_type      = var.db_instance_type
  db_name           = "ecommercedb"
  db_username       = var.db_username
  db_password       = coalesce(var.db_password, random_password.db_password.result)
  private_subnet_ids = module.vpc.private_db_subnet_ids
  security_group_id  = module.security_groups.database_sg_id
}


# S3 Module
module "s3" {
  source = "./modules/s3"

  environment = var.environment
}

# Jenkins Module
# Jenkins Module
module "jenkins" {
  source = "./modules/jenkins"

  environment        = var.environment
  instance_type      = var.jenkins_instance_type
  key_name           = aws_key_pair.ecommerce.key_name
  public_subnet_ids  = module.vpc.public_subnet_ids
  security_group_id  = module.security_groups.jenkins_sg_id
}

