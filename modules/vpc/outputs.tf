# VPC ID
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

# Public subnet IDs
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

# Private app subnet IDs
output "private_app_subnet_ids" {
  description = "List of private app subnet IDs"
  value       = aws_subnet.private_app[*].id
}

# Private DB subnet IDs
output "private_db_subnet_ids" {
  description = "List of private database subnet IDs"
  value       = aws_subnet.private_db[*].id
}