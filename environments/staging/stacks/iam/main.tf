module "iam" {
  source     = "git::https://github.com/temitayocharles/terraform-module.git//module/iam?ref=v1.0.0"
  iam_config = local.env.iam_config
}

module "oidc" {
  count  = try(local.env.oidc_config.enable_github_oidc, false) ? 1 : 0
  source = "git::https://github.com/temitayocharles/terraform-module.git//module/oidc?ref=v1.0.0"
  oidc_config = {
    providers_config = try(local.env.oidc_config.providers_config, [])
    region           = local.env.aws_config.region
  }
}
