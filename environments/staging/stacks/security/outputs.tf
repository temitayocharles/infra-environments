output "jenkins_sg_id" {
  value       = try(module.jenkins_sg[0].security_group_id, "")
  description = "Security group ID for Jenkins access."
}

output "k8s_master_sg_id" {
  value       = try(module.k8s_master_sg[0].security_group_id, "")
  description = "Security group ID for Kubernetes masters."
}

output "k8s_worker_sg_id" {
  value       = try(module.k8s_worker_sg[0].security_group_id, "")
  description = "Security group ID for Kubernetes workers."
}

output "tools_sg_id" {
  value       = try(module.tools_sg[0].security_group_id, "")
  description = "Security group ID for shared tooling."
}

output "monitoring_sg_id" {
  value       = try(module.monitoring_sg[0].security_group_id, "")
  description = "Security group ID for monitoring workloads."
}
