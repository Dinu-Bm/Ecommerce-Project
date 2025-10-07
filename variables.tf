# AWS region
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"  # or change to your preferred region
}

# VPC CIDR block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Environment name (e.g., dev, prod)
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# List of availability zones
variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "key_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
  default     = "ecommerce-key"
}

variable "db_instance_type" {
  description = "RDS instance type"
  type        = string
  default     = "db.t2.micro"  # Free tier eligible
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "jenkins_instance_type" {
  description = "EC2 instance type for Jenkins server"
  type        = string
  default     = "t2.micro"  # Free tier eligible
}