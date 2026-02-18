module "jenkins_sg" {
  count             = try(local.env.modules_enabled.jenkins_sg, false) ? 1 : 0
  source            = "git::https://github.com/temitayocharles/terraform-module.git//module/sg-dynamic?ref=main"
  sg_dynamic_config = local.env.jenkins_sg_config
}

module "k8s_master_sg" {
  count             = try(local.env.modules_enabled.k8s_master_sg, false) ? 1 : 0
  source            = "git::https://github.com/temitayocharles/terraform-module.git//module/sg-dynamic?ref=main"
  sg_dynamic_config = local.env.k8s_master_sg_config
}

module "k8s_worker_sg" {
  count             = try(local.env.modules_enabled.k8s_worker_sg, false) ? 1 : 0
  source            = "git::https://github.com/temitayocharles/terraform-module.git//module/sg-dynamic?ref=main"
  sg_dynamic_config = local.env.k8s_worker_sg_config
}
