terraform {
  required_version = ">= 1.6.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  env = yamldecode(file("${path.module}/../../environment.yaml"))
}

provider "aws" {
  region = local.env.aws_config.region
}
