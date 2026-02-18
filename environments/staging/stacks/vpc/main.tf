module "vpc" {
  source     = "git::https://github.com/temitayocharles/terraform-module.git//module/vpc?ref=v1.0.0"
  vpc_config = local.env.vpc_config
}
