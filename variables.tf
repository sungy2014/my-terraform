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
  description = "Environment name (e.g. production, staging, development)"
  type        = string
  default     = "production"
}

variable "enable_versioning" {
  description = "Enable or disable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Name        = ""
    Environment = "production"
    ManagedBy   = "terraform"
  }
}