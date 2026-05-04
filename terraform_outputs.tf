output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "s3_bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "s3_bucket_regional_domain_name" {
  description = "The bucket regional domain name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "s3_bucket_versioning_status" {
  description = "The versioning status of the S3 bucket"
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}