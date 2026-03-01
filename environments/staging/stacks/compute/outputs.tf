output "master_instance_ids" {
  value       = try(module.ec2_cluster[0].master_instance_ids, [])
  description = "IDs of EC2 cluster master instances."
}

output "worker_instance_ids" {
  value       = try(module.ec2_cluster[0].worker_instance_ids, [])
  description = "IDs of EC2 cluster worker instances."
}

output "cluster_name" {
  value       = try(module.eks[0].cluster_name, "")
  description = "EKS cluster name."
}

output "cluster_endpoint" {
  value       = try(module.eks[0].cluster_endpoint, "")
  description = "EKS cluster endpoint."
}

output "ecs_cluster_arn" {
  value       = try(module.ecs_fargate[0].cluster_arn, "")
  description = "ECS cluster ARN."
}

output "ecs_service_name" {
  value       = try(module.ecs_fargate[0].service_name, "")
  description = "ECS service name."
}
