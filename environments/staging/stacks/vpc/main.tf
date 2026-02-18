module "vpc" {
  source     = "git::https://github.com/temitayocharles/terraform-module.git//module/vpc?ref=main"
  vpc_config = local.env.vpc_config
}
