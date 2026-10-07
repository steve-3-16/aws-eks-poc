resource "aws_route53_zone" "private" {
  name = "steve316.shop"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.provider}-r53-${local.project}-${local.environment}-${local.region_code}-private01"
  })
}

/*resource "aws_route53_record" "alb" {
  zone_id = aws_route53_zone.private.id
  name    = "app.steve316.shop"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}*/