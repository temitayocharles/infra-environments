terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
  }
}

locals {
  env                = yamldecode(file("${path.module}/../../environment.yaml"))
  bootstrap_config   = local.env.argocd_bootstrap_config
  auth_mode          = try(local.bootstrap_config.auth_mode, "eks")
  bootstrap_enabled  = try(local.env.modules_enabled.argocd_bootstrap, false)
  use_eks            = local.bootstrap_enabled && local.auth_mode == "eks"
  use_kubeconfig     = local.bootstrap_enabled && local.auth_mode == "kubeconfig"
  cluster_name       = try(local.bootstrap_config.cluster_name, local.env.eks_config.name)
  kubeconfig_path    = try(local.bootstrap_config.kubeconfig_path, null)
  kubeconfig_context = try(local.bootstrap_config.kubeconfig_context, null)
}

provider "aws" {
  region                      = local.env.aws_config.region
  access_key                  = local.use_kubeconfig ? "bootstrap-local" : null
  secret_key                  = local.use_kubeconfig ? "bootstrap-local" : null
  skip_credentials_validation = local.use_kubeconfig
  skip_requesting_account_id  = local.use_kubeconfig
  skip_metadata_api_check     = local.use_kubeconfig
  skip_region_validation      = local.use_kubeconfig
}

data "aws_eks_cluster" "this" {
  count = local.use_eks ? 1 : 0
  name  = local.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  count = local.use_eks ? 1 : 0
  name  = local.cluster_name
}

provider "kubernetes" {
  host                   = local.use_eks ? try(data.aws_eks_cluster.this[0].endpoint, null) : null
  cluster_ca_certificate = local.use_eks ? try(base64decode(data.aws_eks_cluster.this[0].certificate_authority[0].data), null) : null
  token                  = local.use_eks ? try(data.aws_eks_cluster_auth.this[0].token, null) : null
  config_path            = local.use_kubeconfig ? local.kubeconfig_path : null
  config_context         = local.use_kubeconfig ? local.kubeconfig_context : null
}

provider "helm" {
  kubernetes {
    host                   = local.use_eks ? try(data.aws_eks_cluster.this[0].endpoint, null) : null
    cluster_ca_certificate = local.use_eks ? try(base64decode(data.aws_eks_cluster.this[0].certificate_authority[0].data), null) : null
    token                  = local.use_eks ? try(data.aws_eks_cluster_auth.this[0].token, null) : null
    config_path            = local.use_kubeconfig ? local.kubeconfig_path : null
    config_context         = local.use_kubeconfig ? local.kubeconfig_context : null
  }
}
