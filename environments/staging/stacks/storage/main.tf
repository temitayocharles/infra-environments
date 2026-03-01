locals {
  vpc_subnet_ids = try(data.terraform_remote_state.vpc[0].outputs.subnet_ids, [])
  efs_config = merge(local.env.efs_config, {
    subnet_ids = length(local.env.efs_config.subnet_ids) > 0 ? local.env.efs_config.subnet_ids : local.vpc_subnet_ids
  })
}

module "s3" {
  count     = try(local.env.modules_enabled.s3, false) ? 1 : 0
  source    = "git::https://github.com/temitayocharles/terraform-module.git//module/s3?ref=v1.0.0"
  s3_config = local.env.s3_config
}

module "ecr" {
  count      = try(local.env.modules_enabled.ecr, false) ? 1 : 0
  source     = "git::https://github.com/temitayocharles/terraform-module.git//module/ecr?ref=v1.0.0"
  ecr_config = local.env.ecr_config
}

module "efs" {
  count      = try(local.env.modules_enabled.efs, false) ? 1 : 0
  source     = "git::https://github.com/temitayocharles/terraform-module.git//module/efs?ref=v1.0.0"
  efs_config = local.efs_config
}
