output "alb_sg_id" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb.id
}

output "app_sg_id" {
  description = "Application Security Group ID"
  value       = aws_security_group.app.id
}

output "database_sg_id" {
  description = "Database Security Group ID"
  value       = aws_security_group.database.id
}

output "jenkins_sg_id" {
  description = "Jenkins Security Group ID"
  value       = aws_security_group.jenkins.id
}