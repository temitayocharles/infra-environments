module "rds" {
  count      = try(local.env.modules_enabled.rds, false) ? 1 : 0
  source     = "git::https://github.com/temitayocharles/terraform-module.git//module/rds?ref=main"
  rds_config = local.env.rds_config
}

module "rotation_lambda" {
  count                  = try(local.env.modules_enabled.rotation_lambda, false) ? 1 : 0
  source                 = "git::https://github.com/temitayocharles/terraform-module.git//module/rotation_lambda?ref=main"
  rotation_lambda_config = local.env.rotation_lambda_config
}
