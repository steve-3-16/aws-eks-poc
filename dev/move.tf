moved {
  from = aws_lb_target_group_attachment.nlb_bastion
  to   = aws_lb_target_group_attachment.private_nlb
}

moved {
  from = aws_lb_target_group.nlb_bastion
  to   = aws_lb_target_group.private_nlb
}

