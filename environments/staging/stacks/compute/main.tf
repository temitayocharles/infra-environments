locals {
  vpc_subnet_ids      = try(data.terraform_remote_state.vpc[0].outputs.subnet_ids, [])
  default_subnet_id   = length(local.vpc_subnet_ids) > 0 ? local.vpc_subnet_ids[0] : ""
  jenkins_sg_id       = try(data.terraform_remote_state.security[0].outputs.jenkins_sg_id, "")
  k8s_master_sg_id    = try(data.terraform_remote_state.security[0].outputs.k8s_master_sg_id, "")
  k8s_worker_sg_id    = try(data.terraform_remote_state.security[0].outputs.k8s_worker_sg_id, "")
  tools_sg_id         = try(data.terraform_remote_state.security[0].outputs.tools_sg_id, "")
  monitoring_sg_id    = try(data.terraform_remote_state.security[0].outputs.monitoring_sg_id, "")
  default_cluster_sgs = compact([local.k8s_master_sg_id, local.k8s_worker_sg_id])
  default_service_sgs = compact([local.tools_sg_id, local.monitoring_sg_id, local.k8s_worker_sg_id])

  ec2_cluster_config = merge(local.env.ec2_cluster_config, {
    subnet_id = local.env.ec2_cluster_config.subnet_id != "" ? local.env.ec2_cluster_config.subnet_id : local.default_subnet_id
    vpc_security_group_ids = length(local.env.ec2_cluster_config.vpc_security_group_ids) > 0 ? local.env.ec2_cluster_config.vpc_security_group_ids : local.default_cluster_sgs
    iam_instance_profile = local.env.ec2_cluster_config.iam_instance_profile != "" ? local.env.ec2_cluster_config.iam_instance_profile : coalesce(
      try(data.terraform_remote_state.iam[0].outputs.k8s_worker_instance_profile_name, ""),
      try(data.terraform_remote_state.iam[0].outputs.jenkins_instance_profile_name, ""),
      ""
    )
  })

  ecs_fargate_config = merge(local.env.ecs_fargate_config, {
    subnet_ids = length(local.env.ecs_fargate_config.subnet_ids) > 0 ? local.env.ecs_fargate_config.subnet_ids : local.vpc_subnet_ids
    security_group_ids = length(local.env.ecs_fargate_config.security_group_ids) > 0 ? local.env.ecs_fargate_config.security_group_ids : local.default_service_sgs
  })

  eks_config = merge(local.env.eks_config, {
    subnet_ids = length(local.env.eks_config.subnet_ids) > 0 ? local.env.eks_config.subnet_ids : local.vpc_subnet_ids
  })
}

module "ec2_cluster" {
  count              = try(local.env.modules_enabled.ec2_cluster, false) ? 1 : 0
  source             = "git::https://github.com/temitayocharles/terraform-module.git//module/ec2-cluster?ref=v1.0.0"
  ec2_cluster_config = local.ec2_cluster_config
}

module "ecs_fargate" {
  count              = try(local.env.modules_enabled.ecs_fargate, false) ? 1 : 0
  source             = "git::https://github.com/temitayocharles/terraform-module.git//module/ecs-fargate?ref=v1.0.0"
  ecs_fargate_config = local.ecs_fargate_config
}

module "eks" {
  count               = try(local.env.modules_enabled.eks, false) ? 1 : 0
  source              = "git::https://github.com/temitayocharles/terraform-module.git//module/eks-practice?ref=v1.0.0"
  eks_practice_config = local.eks_config
}
