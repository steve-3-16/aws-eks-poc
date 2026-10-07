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
}*/

# ============================================================
# Application Load Balancer
# ============================================================

/*resource "aws_lb" "alb" {
  name               = "${local.provider}-alb-${local.project}-${local.environment}-${local.region_code}-alb01"
  internal           = var.alb_scheme == "internal"
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    for subnet in aws_subnet.elb : subnet.id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-alb-${local.project}-${local.environment}-${local.region_code}-alb01"
    }
  )
}

# ============================================================
# ALB Listener
# ============================================================

resource "aws_lb_listener" "alb" {
  for_each = var.alb_listeners

  load_balancer_arn = aws_lb.alb.arn
  port              = each.value.port
  protocol          = each.value.protocol

  # HTTPS Listner only
  certificate_arn = each.value.protocol == "HTTPS" ? aws_acm_certificate.internal_alb.arn : null

  default_action {
    type = each.value.action_type

    # Forward Listener
    target_group_arn = each.value.action_type == "forward" ? aws_lb_target_group.alb.arn : null

    # Redirect Listener
    dynamic "redirect" {
      for_each = each.value.action_type == "redirect" ? [1] : []

      content {
        port        = tostring(each.value.redirect_port)
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }
}*/
