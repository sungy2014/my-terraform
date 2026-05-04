variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "production"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-s3-bucket-11"
}