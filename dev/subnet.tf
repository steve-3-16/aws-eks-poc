locals {
  subnet_prefix = "${local.provider}-isnet-${local.project}-${local.environment}-${local.region_code}"

  subnet_configs = {
    public_a  = { name = "${local.subnet_prefix}-pub01", cidr_block = "10.0.1.0/24", availability_zone = "ap-northeast-2a", map_public_ip_on_launch = true }
    public_c  = { name = "${local.subnet_prefix}-pub02", cidr_block = "10.0.2.0/24", availability_zone = "ap-northeast-2c", map_public_ip_on_launch = true }
    elb_a     = { name = "${local.subnet_prefix}-elb01", cidr_block = "10.0.11.0/24", availability_zone = "ap-northeast-2a" }
    elb_c     = { name = "${local.subnet_prefix}-elb02", cidr_block = "10.0.12.0/24", availability_zone = "ap-northeast-2c" }
    compute_a = { name = "${local.subnet_prefix}-compute01", cidr_block = "10.0.21.0/24", availability_zone = "ap-northeast-2a", tags = local.common_tags }
    compute_c = { name = "${local.subnet_prefix}-compute02", cidr_block = "10.0.22.0/24", availability_zone = "ap-northeast-2c", tags = local.common_tags }
    vpce_a    = { name = "${local.subnet_prefix}-vpce01", cidr_block = "10.0.41.0/24", availability_zone = "ap-northeast-2a", tags = local.common_tags }
    vpce_c    = { name = "${local.subnet_prefix}-vpce02", cidr_block = "10.0.42.0/24", availability_zone = "ap-northeast-2c", tags = local.common_tags }
    db_a      = { name = "${local.subnet_prefix}-db01", cidr_block = "10.0.31.0/24", availability_zone = "ap-northeast-2a", tags = local.common_tags }
    db_c      = { name = "${local.subnet_prefix}-db02", cidr_block = "10.0.32.0/24", availability_zone = "ap-northeast-2c", tags = local.common_tags }
    tgw_a     = { name = "${local.subnet_prefix}-tgw01", cidr_block = "10.0.61.0/24", availability_zone = "ap-northeast-2a", tags = local.common_tags }
    tgw_c     = { name = "${local.subnet_prefix}-tgw02", cidr_block = "10.0.62.0/24", availability_zone = "ap-northeast-2c", tags = local.common_tags }
    eks_a     = { name = "${local.subnet_prefix}-eks01", cidr_block = "10.0.71.0/24", availability_zone = "ap-northeast-2a", tags = local.common_tags }
    eks_c     = { name = "${local.subnet_prefix}-eks02", cidr_block = "10.0.72.0/24", availability_zone = "ap-northeast-2c", tags = local.common_tags }
  }
}

module "subnet" {
  source  = "../modules/network/subnet"
  vpc_id  = module.vpc.vpc_id
  subnets = local.subnet_configs
}