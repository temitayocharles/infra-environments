output "jenkins_instance_profile_name" {
  value       = module.iam.jenkins_instance_profile_name
  description = "Jenkins instance profile name."
}

output "k8s_worker_instance_profile_name" {
  value       = module.iam.k8s_worker_instance_profile_name
  description = "Kubernetes worker instance profile name."
}

output "roles" {
  value       = module.iam.roles
  description = "IAM role ARNs created by the IAM stack."
}
