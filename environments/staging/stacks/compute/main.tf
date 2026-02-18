module "ec2_cluster" {
  count              = try(local.env.modules_enabled.ec2_cluster, false) ? 1 : 0
  source             = "git::https://github.com/temitayocharles/terraform-module.git//module/ec2-cluster?ref=main"
  ec2_cluster_config = local.env.ec2_cluster_config
}

module "ecs_fargate" {
  count              = try(local.env.modules_enabled.ecs_fargate, false) ? 1 : 0
  source             = "git::https://github.com/temitayocharles/terraform-module.git//module/ecs-fargate?ref=main"
  ecs_fargate_config = local.env.ecs_fargate_config
}

module "eks" {
  count               = try(local.env.modules_enabled.eks, false) ? 1 : 0
  source              = "git::https://github.com/temitayocharles/terraform-module.git//module/eks-practice?ref=main"
  eks_practice_config = local.env.eks_practice_config
}
