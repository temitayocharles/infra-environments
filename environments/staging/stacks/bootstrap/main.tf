module "argocd_bootstrap" {
  count = try(local.env.modules_enabled.argocd_bootstrap, false) ? 1 : 0

  source = "git::https://github.com/temitayocharles/terraform-module.git//module/argocd-bootstrap?ref=v1.1.1"

  argocd_bootstrap_config = local.env.argocd_bootstrap_config
  repo_passwords          = var.argocd_repo_passwords
}
