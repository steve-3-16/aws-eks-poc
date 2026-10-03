/*
resource "aws_lb" "private_nlb" {
  name               = "${local.provider}-nlb-${local.project}-${local.environment}-${local.region_code}-nlb01"
  internal           = var.nlb_scheme == "internal"
  load_balancer_type = "network"

  security_groups = [
    aws_security_group.private_nlb.id
  ]

  subnets = [
    for subnet in aws_subnet.elb : subnet.id
  ]

  enable_cross_zone_load_balancing = var.nlb_cross_zone_enabled

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-nlb-${local.project}-${local.environment}-${local.region_code}-nlb01"
    }
  )
}

resource "aws_lb_listener" "private_nlb" {
  load_balancer_arn = aws_lb.private_nlb.arn

  port     = var.nlb_listner_port
  protocol = var.nlb_listner_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_nlb.arn
  }
}
*/