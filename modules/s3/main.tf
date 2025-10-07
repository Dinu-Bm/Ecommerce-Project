# S3 Bucket for application logs
resource "aws_s3_bucket" "logs" {
  bucket = "${var.environment}-terraform-ecommerce-logs-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.environment}-ecommerce-logs"
    Environment = var.environment
  }
}

# S3 Bucket for terraform state (created separately)
resource "aws_s3_bucket" "terraform_state" {
  bucket = "ecommerce-terraform-state-2025-2025-${var.environment}"

  tags = {
    Name        = "ecommerce-terraform-state-${var.environment}"
    Environment = var.environment
  }
}

# Enable versioning for state bucket
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access for both buckets
resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Random suffix for bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 8
}