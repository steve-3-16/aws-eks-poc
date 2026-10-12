moved {
  from = aws_lb_target_group_attachment.nlb_bastion
  to   = aws_lb_target_group_attachment.private_nlb
}

moved {
  from = aws_lb_target_group.nlb_bastion
  to   = aws_lb_target_group.private_nlb
}

moved {
  from = aws_vpc.main
  to   = module.vpc.aws_vpc.this
}

# Public
moved {
  from = aws_subnet.public["public_a"]
  to   = module.subnet.aws_subnet.this["public_a"]
}

moved {
  from = aws_subnet.public["public_c"]
  to   = module.subnet.aws_subnet.this["public_c"]
}

# ELB
moved {
  from = aws_subnet.elb["elb_a"]
  to   = module.subnet.aws_subnet.this["elb_a"]
}

moved {
  from = aws_subnet.elb["elb_c"]
  to   = module.subnet.aws_subnet.this["elb_c"]
}

# Compute
moved {
  from = aws_subnet.compute[0]
  to   = module.subnet.aws_subnet.this["compute_a"]
}

moved {
  from = aws_subnet.compute[1]
  to   = module.subnet.aws_subnet.this["compute_c"]
}

# VPCE
moved {
  from = aws_subnet.vpce[0]
  to   = module.subnet.aws_subnet.this["vpce_a"]
}

moved {
  from = aws_subnet.vpce[1]
  to   = module.subnet.aws_subnet.this["vpce_c"]
}

# DB
moved {
  from = aws_subnet.db[0]
  to   = module.subnet.aws_subnet.this["db_a"]
}

moved {
  from = aws_subnet.db[1]
  to   = module.subnet.aws_subnet.this["db_c"]
}

# TGW
moved {
  from = aws_subnet.tgw[0]
  to   = module.subnet.aws_subnet.this["tgw_a"]
}

moved {
  from = aws_subnet.tgw[1]
  to   = module.subnet.aws_subnet.this["tgw_c"]
}

# EKS
moved {
  from = aws_subnet.eks[0]
  to   = module.subnet.aws_subnet.this["eks_a"]
}

moved {
  from = aws_subnet.eks[1]
  to   = module.subnet.aws_subnet.this["eks_c"]
}