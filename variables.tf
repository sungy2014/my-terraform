variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name used for tagging and resource naming"
  type        = string
  default     = "production"
}

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name (a random suffix will be appended for uniqueness)"
  type        = string
  default     = "my-terraform-bucket"
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable default SSE-S3 encryption on the bucket"
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Block public ACLs on the bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs on the bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public bucket access"
  type        = bool
  default     = true
}

variable "default_tags" {
  description = "Default tags applied to all resources"
  type        = map(string)
  default = {
    Name        = "s3-bucket"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}