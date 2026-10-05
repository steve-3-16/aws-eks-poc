resource "aws_acm_certificate" "internal_alb" {
  domain_name       = "*.steve316.shop"
  validation_method = "DNS"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-acm-${local.project}-${local.environment}-${local.region_code}-internal-alb01"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}