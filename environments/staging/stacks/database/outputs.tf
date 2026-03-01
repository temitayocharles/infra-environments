output "rds_endpoint" {
  value       = try(module.rds[0].endpoint, "")
  description = "RDS endpoint including port."
}

output "rds_address" {
  value       = try(module.rds[0].address, "")
  description = "RDS address."
}

output "rds_instance_id" {
  value       = try(module.rds[0].instance_id, "")
  description = "RDS instance identifier."
}

output "rds_secret_arn" {
  value       = try(module.rds[0].secret_arn, "")
  description = "Secrets Manager ARN for RDS credentials."
}

output "rds_security_group_id" {
  value       = try(module.rds[0].security_group_id, "")
  description = "Security group used by the RDS instance."
}

output "rotation_lambda_arn" {
  value       = try(module.rotation_lambda[0].lambda_arn, "")
  description = "Rotation Lambda ARN."
}
