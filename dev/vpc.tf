module "vpc" {
  source = "../modules/network/vpc"

  vpc_cidr = var.vpc_cidr
  vpc_name = local.vpc_name
}