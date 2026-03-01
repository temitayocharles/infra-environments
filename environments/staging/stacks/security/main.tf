locals {
  vpc_id = try(data.terraform_remote_state.vpc[0].outputs.vpc_id, "")

  jenkins_sg_config = merge(local.env.jenkins_sg_config, {
    vpc_id = local.env.jenkins_sg_config.vpc_id != "" ? local.env.jenkins_sg_config.vpc_id : local.vpc_id
  })

  k8s_master_sg_config = merge(local.env.k8s_master_sg_config, {
    vpc_id = local.env.k8s_master_sg_config.vpc_id != "" ? local.env.k8s_master_sg_config.vpc_id : local.vpc_id
  })

  k8s_worker_sg_config = merge(local.env.k8s_worker_sg_config, {
    vpc_id = local.env.k8s_worker_sg_config.vpc_id != "" ? local.env.k8s_worker_sg_config.vpc_id : local.vpc_id
  })

  tools_sg_config = merge(local.env.tools_sg_config, {
    vpc_id = local.env.tools_sg_config.vpc_id != "" ? local.env.tools_sg_config.vpc_id : local.vpc_id
  })

  monitoring_sg_config = merge(local.env.monitoring_sg_config, {
    vpc_id = local.env.monitoring_sg_config.vpc_id != "" ? local.env.monitoring_sg_config.vpc_id : local.vpc_id
  })
}

module "jenkins_sg" {
  count             = try(local.env.modules_enabled.jenkins_sg, false) ? 1 : 0
  source            = "git::https://github.com/temitayocharles/terraform-module.git//module/sg-dynamic?ref=v1.0.0"
  sg_dynamic_config = local.jenkins_sg_config
}

module "k8s_master_sg" {
  count             = try(local.env.modules_enabled.k8s_master_sg, false) ? 1 : 0
  source            = "git::https://github.com/temitayocharles/terraform-module.git//module/sg-dynamic?ref=v1.0.0"
  sg_dynamic_config = local.k8s_master_sg_config
}

module "k8s_worker_sg" {
  count             = try(local.env.modules_enabled.k8s_worker_sg, false) ? 1 : 0
  source            = "git::https://github.com/temitayocharles/terraform-module.git//module/sg-dynamic?ref=v1.0.0"
  sg_dynamic_config = local.k8s_worker_sg_config
}

module "tools_sg" {
  count             = try(local.env.modules_enabled.tools_sg, false) ? 1 : 0
  source            = "git::https://github.com/temitayocharles/terraform-module.git//module/sg-dynamic?ref=v1.0.0"
  sg_dynamic_config = local.tools_sg_config
}

module "monitoring_sg" {
  count             = try(local.env.modules_enabled.monitoring_sg, false) ? 1 : 0
  source            = "git::https://github.com/temitayocharles/terraform-module.git//module/sg-dynamic?ref=v1.0.0"
  sg_dynamic_config = local.monitoring_sg_config
}

