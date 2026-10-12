resource "aws_internet_gateway" "main" {
  vpc_id = module.vpc.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-igw-${local.project}-${local.environment}-${local.region_code}-01"
    }
  )
}
