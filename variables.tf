variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
  default     = "my-test-bucket-12345"
}

variable "environment" {
  description = "Environment tag for the bucket"
  type        = string
  default     = "dev"
}