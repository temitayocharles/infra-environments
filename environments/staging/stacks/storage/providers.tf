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

data "terraform_remote_state" "vpc" {
  count   = try(local.env.remote_state.vpc.bucket, "") != "" && try(local.env.remote_state.vpc.key, "") != "" ? 1 : 0
  backend = "s3"

  config = merge({
    bucket  = try(local.env.remote_state.vpc.bucket, "") != "" ? local.env.remote_state.vpc.bucket : "placeholder-bucket"
    key     = try(local.env.remote_state.vpc.key, "") != "" ? local.env.remote_state.vpc.key : "placeholder-key"
    region  = try(local.env.remote_state.vpc.region, "") != "" ? local.env.remote_state.vpc.region : "us-east-1"
    encrypt = try(local.env.remote_state.vpc.encrypt, true)
    }, try(local.env.remote_state.vpc.dynamodb_table, "") != "" ? {
    dynamodb_table = local.env.remote_state.vpc.dynamodb_table
  } : {})
}
