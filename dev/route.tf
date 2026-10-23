
# ==========================================
# Route Table - Locals
# ==========================================

locals {
  route_table_prefix = "${local.provider}-irot-${local.project}-${local.environment}-${local.region_code}"

  route_table_configs = {
    # Public
    public_a = { name = "${local.route_table_prefix}-pub01" }
    public_c = { name = "${local.route_table_prefix}-pub02" }

    # ELB
    elb_a = { name = "${local.route_table_prefix}-elb01" }
    elb_c = { name = "${local.route_table_prefix}-elb02" }

    # Compute
    compute_a = { name = "${local.route_table_prefix}-compute01" }
    compute_c = { name = "${local.route_table_prefix}-compute02" }

    # VPCE
    vpce_a = { name = "${local.route_table_prefix}-vpce01" }
    vpce_c = { name = "${local.route_table_prefix}-vpce02" }

    # DB
    db_a = { name = "${local.route_table_prefix}-db01" }
    db_c = { name = "${local.route_table_prefix}-db02" }

    # TGW
    tgw_a = { name = "${local.route_table_prefix}-tgw01" }
    tgw_c = { name = "${local.route_table_prefix}-tgw02" }

    # EKS
    eks_a = { name = "${local.route_table_prefix}-eks01" }
    eks_c = { name = "${local.route_table_prefix}-eks02" }
  }
}


# ==========================================
# Route Table Module
# ==========================================

module "route_table" {
  source = "../modules/network/route_table"

  # Common
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.subnet.subnet_ids
  common_tags = local.common_tags

  # Route Tables
  route_tables = local.route_table_configs

  # Subnet Associations
  route_table_associations = {
    for key in keys(local.route_table_configs) : key => {
      subnet_key      = key
      route_table_key = key
    }
  }

  # Routes
  routes = {
    # Public A -> Internet Gateway
    public_a = {
      route_table_key        = "public_a"
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = aws_internet_gateway.main.id
    }

    # Public C -> Internet Gateway
    public_c = {
      route_table_key        = "public_c"
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = aws_internet_gateway.main.id
    }
  }
}
