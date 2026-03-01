output "bucket_name" {
  value       = try(module.s3[0].bucket_name, "")
  description = "S3 bucket name."
}

output "repository_url" {
  value       = try(module.ecr[0].repository_url, "")
  description = "ECR repository URL."
}

output "file_system_id" {
  value       = try(module.efs[0].file_system_id, "")
  description = "EFS file system identifier."
}
