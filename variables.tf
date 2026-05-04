variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "The deployment environment"
  type        = string
  default     = "production"
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default = {
    Name        = "my-s3-bucket-9"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}