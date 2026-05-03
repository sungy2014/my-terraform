variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment label for tagging"
  type        = string
  default     = "production"
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Name        = "my-s3-bucket-5"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}