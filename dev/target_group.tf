/*resource "aws_lb_target_group" "private_nlb" {
  name        = "a-tg-steve-dev-ane2-nlb01"
  port        = var.nlb_tg_port
  protocol    = var.nlb_tg_protocol
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled             = true
    protocol            = var.nlb_tg_health_check_protocol
    port                = "traffic-port"
    path                = var.nlb_tg_health_check_path
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = var.nlb_tg_health_check_interval
  }

  tags = merge(local.common_tags, {
    Name = "a-tg-steve-dev-ane2-nlb01"
  })
}

resource "aws_lb_target_group_attachment" "private_nlb" {
  target_group_arn = aws_lb_target_group.private_nlb.arn
  target_id        = aws_instance.bastion.id
  port             = var.nlb_tg_port
}
*/

# ============================================================
# ALB Target Group
# ============================================================

resource "aws_lb_target_group" "alb" {
  name        = "${local.provider}-tg-${local.project}-${local.environment}-${local.region_code}-alb01"
  port        = var.alb_tg_port
  protocol    = var.alb_tg_protocol
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled             = true
    protocol            = var.alb_tg_protocol
    port                = "traffic-port"
    path                = var.alb_health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-tg-${local.project}-${local.environment}-${local.region_code}-alb01"
    }
  )
}
