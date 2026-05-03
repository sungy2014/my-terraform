variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The globally unique name for the S3 bucket"
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g. production, staging, dev)"
  type        = string
  default     = "production"
}

variable "enable_versioning" {
  description = "Enable or disable versioning on the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable or disable default server-side encryption"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}