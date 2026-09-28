resource "aws_route53_zone" "private" {
  name = "steve316.shop"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.provider}-r53-${local.project}-${local.environment}-${local.region_code}-private01"
  })
}
