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

# ==========================================
# Route Table (14)
# ==========================================

# Public
moved {
  from = aws_route_table.public_a
  to   = module.route_table.aws_route_table.this["public_a"]
}

moved {
  from = aws_route_table.public_c
  to   = module.route_table.aws_route_table.this["public_c"]
}

# ELB
moved {
  from = aws_route_table.elb_a
  to   = module.route_table.aws_route_table.this["elb_a"]
}

moved {
  from = aws_route_table.elb_c
  to   = module.route_table.aws_route_table.this["elb_c"]
}

# Compute
moved {
  from = aws_route_table.compute[0]
  to   = module.route_table.aws_route_table.this["compute_a"]
}

moved {
  from = aws_route_table.compute[1]
  to   = module.route_table.aws_route_table.this["compute_c"]
}

# VPCE
moved {
  from = aws_route_table.vpce[0]
  to   = module.route_table.aws_route_table.this["vpce_a"]
}

moved {
  from = aws_route_table.vpce[1]
  to   = module.route_table.aws_route_table.this["vpce_c"]
}

# DB
moved {
  from = aws_route_table.db[0]
  to   = module.route_table.aws_route_table.this["db_a"]
}

moved {
  from = aws_route_table.db[1]
  to   = module.route_table.aws_route_table.this["db_c"]
}

# TGW
moved {
  from = aws_route_table.tgw[0]
  to   = module.route_table.aws_route_table.this["tgw_a"]
}

moved {
  from = aws_route_table.tgw[1]
  to   = module.route_table.aws_route_table.this["tgw_c"]
}

# EKS
moved {
  from = aws_route_table.eks_a
  to   = module.route_table.aws_route_table.this["eks_a"]
}

moved {
  from = aws_route_table.eks_c
  to   = module.route_table.aws_route_table.this["eks_c"]
}


# ==========================================
# Route Table Association (13)
# ==========================================

# Public A (Bastion)
moved {
  from = aws_route_table_association.bastion_public
  to   = module.route_table.aws_route_table_association.this["public_a"]
}

# ELB
moved {
  from = aws_route_table_association.elb_a
  to   = module.route_table.aws_route_table_association.this["elb_a"]
}

moved {
  from = aws_route_table_association.elb_c
  to   = module.route_table.aws_route_table_association.this["elb_c"]
}

# Compute
moved {
  from = aws_route_table_association.compute[0]
  to   = module.route_table.aws_route_table_association.this["compute_a"]
}

moved {
  from = aws_route_table_association.compute[1]
  to   = module.route_table.aws_route_table_association.this["compute_c"]
}

# VPCE
moved {
  from = aws_route_table_association.vpce[0]
  to   = module.route_table.aws_route_table_association.this["vpce_a"]
}

moved {
  from = aws_route_table_association.vpce[1]
  to   = module.route_table.aws_route_table_association.this["vpce_c"]
}

# DB
moved {
  from = aws_route_table_association.db[0]
  to   = module.route_table.aws_route_table_association.this["db_a"]
}

moved {
  from = aws_route_table_association.db[1]
  to   = module.route_table.aws_route_table_association.this["db_c"]
}

# TGW
moved {
  from = aws_route_table_association.tgw[0]
  to   = module.route_table.aws_route_table_association.this["tgw_a"]
}

moved {
  from = aws_route_table_association.tgw[1]
  to   = module.route_table.aws_route_table_association.this["tgw_c"]
}

# EKS
moved {
  from = aws_route_table_association.eks_a
  to   = module.route_table.aws_route_table_association.this["eks_a"]
}

moved {
  from = aws_route_table_association.eks_c
  to   = module.route_table.aws_route_table_association.this["eks_c"]
}


# ==========================================
# Route (2)
# ==========================================

moved {
  from = aws_route.public_a
  to   = module.route_table.aws_route.this["public_a"]
}

moved {
  from = aws_route.public_c
  to   = module.route_table.aws_route.this["public_c"]
}