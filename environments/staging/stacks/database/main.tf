locals {
  vpc_id                     = try(data.terraform_remote_state.vpc[0].outputs.vpc_id, "")
  vpc_subnet_ids             = try(data.terraform_remote_state.vpc[0].outputs.subnet_ids, [])
  jenkins_sg_id              = try(data.terraform_remote_state.security[0].outputs.jenkins_sg_id, "")
  k8s_master_sg_id           = try(data.terraform_remote_state.security[0].outputs.k8s_master_sg_id, "")
  k8s_worker_sg_id           = try(data.terraform_remote_state.security[0].outputs.k8s_worker_sg_id, "")
  tools_sg_id                = try(data.terraform_remote_state.security[0].outputs.tools_sg_id, "")
  monitoring_sg_id           = try(data.terraform_remote_state.security[0].outputs.monitoring_sg_id, "")
  default_allowed_source_sgs = compact([local.k8s_worker_sg_id, local.tools_sg_id, local.monitoring_sg_id, local.jenkins_sg_id, local.k8s_master_sg_id])

  rds_config = merge(local.env.rds_config, {
    subnet_ids = length(local.env.rds_config.subnet_ids) > 0 ? local.env.rds_config.subnet_ids : local.vpc_subnet_ids
    vpc_id = local.env.rds_config.vpc_id != "" ? local.env.rds_config.vpc_id : local.vpc_id
    allowed_source_security_group_ids = length(local.env.rds_config.allowed_source_security_group_ids) > 0 ? local.env.rds_config.allowed_source_security_group_ids : local.default_allowed_source_sgs
    rotation_lambda_arn = local.env.rds_config.rotation_lambda_arn != "" ? local.env.rds_config.rotation_lambda_arn : try(module.rotation_lambda[0].lambda_arn, "")
  })
}

module "rds" {
  count      = try(local.env.modules_enabled.rds, false) ? 1 : 0
  source     = "git::https://github.com/temitayocharles/terraform-module.git//module/rds?ref=v1.0.0"
  rds_config = local.rds_config
}

module "rotation_lambda" {
  count                  = try(local.env.modules_enabled.rotation_lambda, false) ? 1 : 0
  source                 = "git::https://github.com/temitayocharles/terraform-module.git//module/rotation_lambda?ref=v1.0.0"
  rotation_lambda_config = local.env.rotation_lambda_config
}
