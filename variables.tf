variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
}

variable "bucket_acl" {
  description = "The canned ACL to apply to the bucket"
  type        = string
  default     = "private"
}

variable "environment" {
  description = "Environment tag for the bucket"
  type        = string
  default     = "dev"
}

variable "force_destroy" {
  description = "Allow the bucket to be destroyed even if it contains objects"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to attach to the bucket"
  type        = map(string)
  default     = {}
}