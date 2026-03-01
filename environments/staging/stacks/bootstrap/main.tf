module "argocd_bootstrap" {
  count = try(local.env.modules_enabled.argocd_bootstrap, false) ? 1 : 0

  source = "git::https://github.com/temitayocharles/terraform-module.git//module/argocd-bootstrap?ref=v1.1.5"

  argocd_bootstrap_config = local.env.argocd_bootstrap_config
  repo_passwords          = var.argocd_repo_passwords
  kubectl_config = {
    auth_mode              = local.auth_mode
    kubeconfig_path        = local.use_kubeconfig ? local.kubeconfig_path : null
    kubeconfig_context     = local.use_kubeconfig ? local.kubeconfig_context : null
    host                   = local.use_eks ? try(data.aws_eks_cluster.this[0].endpoint, null) : null
    cluster_ca_certificate = local.use_eks ? try(base64decode(data.aws_eks_cluster.this[0].certificate_authority[0].data), null) : null
    token                  = local.use_eks ? try(data.aws_eks_cluster_auth.this[0].token, null) : null
  }
}
