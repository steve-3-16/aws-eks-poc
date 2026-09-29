locals {
  provider    = "a"
  project     = "steve"
  environment = "dev"
  region_code = "ane2"

  vpc_name = "${local.provider}-vpc-${local.project}-${local.environment}-${local.region_code}-01"

  common_tags = {
    Provider    = local.provider
    Project     = local.project
    Environment = local.environment
    Region      = local.region_code
    ManagedBy   = "terraform"
  }
}

locals {
  eks_node_lt_name = "${local.provider}-lt-${local.project}-${local.environment}-${local.region_code}-eks-node"
}
