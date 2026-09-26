locals {
  vpc_name = "a-vpc-steve-dev-ane2-01"
}
locals {
  provider    = "a"
  project     = "steve"
  environment = "dev"
  region_code = "ane2"

  common_tags = {
    Provider    = local.provider
    Project     = local.project
    Environment = local.environment
    Region      = local.region_code
    ManagedBy   = "terraform"
  }
}
