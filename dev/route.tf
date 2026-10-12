
resource "aws_route_table" "public_a" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "a-irot-steve-dev-ane2-pub01"
  }
}

resource "aws_route_table" "public_c" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "a-irot-steve-dev-ane2-pub02"
  }
}

resource "aws_route_table" "elb_a" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "a-irot-steve-dev-ane2-elb01"
  }
}

resource "aws_route_table" "elb_c" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "a-irot-steve-dev-ane2-elb02"
  }
}

resource "aws_route_table" "compute" {
  count = 2

  vpc_id = module.vpc.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-irot-${local.project}-${local.environment}-${local.region_code}-compute0${count.index + 1}"
    }
  )
}

# Public → Internet Gateway
resource "aws_route" "public_a" {
  route_table_id         = aws_route_table.public_a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route" "public_c" {
  route_table_id         = aws_route_table.public_c.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# ELB subnet association
resource "aws_route_table_association" "elb_a" {
  subnet_id      = module.subnet.subnet_ids["elb_a"]
  route_table_id = aws_route_table.elb_a.id
}

resource "aws_route_table_association" "elb_c" {
  subnet_id      = module.subnet.subnet_ids["elb_c"]
  route_table_id = aws_route_table.elb_c.id
}

# Compute subnet association
resource "aws_route_table_association" "compute" {
  count = 2

  subnet_id      = module.subnet.subnet_ids[["compute_a", "compute_c"][count.index]]
  route_table_id = aws_route_table.compute[count.index].id
}

# Bastion public subnet association
resource "aws_route_table_association" "bastion_public" {
  subnet_id      = module.subnet.subnet_ids["public_a"]
  route_table_id = aws_route_table.public_a.id
}

# VPCE Route Table
resource "aws_route_table" "vpce" {
  count = 2

  vpc_id = module.vpc.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-irot-${local.project}-${local.environment}-${local.region_code}-vpce0${count.index + 1}"
    }
  )
}

# VPCE subnet association
resource "aws_route_table_association" "vpce" {
  count = 2

  subnet_id      = module.subnet.subnet_ids[["vpce_a", "vpce_c"][count.index]]
  route_table_id = aws_route_table.vpce[count.index].id
}

# DB Route Table
resource "aws_route_table" "db" {
  count = 2

  vpc_id = module.vpc.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.provider}-irot-${local.project}-${local.environment}-${local.region_code}-db0${count.index + 1}"
  })
}

resource "aws_route_table_association" "db" {
  count = 2

  subnet_id      = module.subnet.subnet_ids[["db_a", "db_c"][count.index]]
  route_table_id = aws_route_table.db[count.index].id
}

# TGW Route Table
resource "aws_route_table" "tgw" {
  count = 2

  vpc_id = module.vpc.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.provider}-irot-${local.project}-${local.environment}-${local.region_code}-tgw0${count.index + 1}"
  })
}

resource "aws_route_table_association" "tgw" {
  count = 2

  subnet_id      = module.subnet.subnet_ids[["tgw_a", "tgw_c"][count.index]]
  route_table_id = aws_route_table.tgw[count.index].id
}

# EKS Route Table
resource "aws_route_table" "eks_a" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "a-irot-steve-dev-ane2-eks01"
  }
}

resource "aws_route_table" "eks_c" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "a-irot-steve-dev-ane2-eks02"
  }
}

# EKS subnet association
resource "aws_route_table_association" "eks_a" {
  subnet_id      = module.subnet.subnet_ids["eks_a"]
  route_table_id = aws_route_table.eks_a.id
}

resource "aws_route_table_association" "eks_c" {
  subnet_id      = module.subnet.subnet_ids["eks_c"]
  route_table_id = aws_route_table.eks_c.id
}
