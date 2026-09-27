resource "aws_ec2_transit_gateway" "main" {
  description = "Steve POC Transit Gateway"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-tgw-${local.project}-${local.environment}-${local.region_code}-01"
    }
  )
}
