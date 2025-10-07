#############################
# Fetch latest Ubuntu AMI (20.04 LTS)
#############################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (official Ubuntu publisher)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#############################
# Jenkins EC2 Instance
#############################
resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_id]

  user_data = templatefile("${path.module}/jenkins_user_data.sh", {
    environment = var.environment
  })

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name        = "${var.environment}-jenkins"
    Environment = var.environment
  }
}

#############################
# Elastic IP for Jenkins
#############################
resource "aws_eip" "jenkins" {
  instance = aws_instance.jenkins.id
  domain   = "vpc"

  tags = {
    Name        = "${var.environment}-jenkins-eip"
    Environment = var.environment
  }
}

#############################
# Outputs
#############################
output "jenkins_public_ip" {
  description = "Public IP of the Jenkins server"
  value       = aws_eip.jenkins.public_ip
}

output "jenkins_instance_id" {
  description = "Instance ID of Jenkins EC2"
  value       = aws_instance.jenkins.id
}