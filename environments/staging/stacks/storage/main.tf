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
