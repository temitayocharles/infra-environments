output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC identifier."
}

output "subnet_ids" {
  value       = module.vpc.subnet_ids
  description = "Subnet identifiers exposed by the VPC stack."
}
