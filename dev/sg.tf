resource "aws_security_group" "import_test" {
  name        = "a-isg-steve-dev-ane2-import01"
  vpc_id      = aws_vpc.main.id
  description = "a-isg-steve-dev-ane2-import01"

  tags = {
    Name = "a-isg-steve-dev-ane2-import01"
  }
}

resource "aws_security_group" "bastion" {
  name        = "a-isg-steve-dev-ane2-bastion01"
  description = "Security group for bastion"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "a-isg-steve-dev-ane2-bastion01"
  }
}

# Ingress : Import test SG → Bastion SSH 22
resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion.id

  referenced_security_group_id = aws_security_group.import_test.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
}

# Ingress : Home public IP → Bastion SSH 22
resource "aws_vpc_security_group_ingress_rule" "bastion_home_ssh" {
  security_group_id = aws_security_group.bastion.id

  description = "Allow SSH from my public IP"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ipv4   = "182.231.63.14/32"
}

# Egress : Bastion → HTTPS 443
resource "aws_vpc_security_group_egress_rule" "bastion_https" {
  security_group_id = aws_security_group.bastion.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  description = "Allow HTTPS outbound traffic"
}

resource "aws_security_group" "import02" {
  name        = "a-isg-steve-dev-ane2-import02"
  description = "a-isg-steve-dev-ane2-import02"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "a-isg-steve-dev-ane2-import02"
  }
}

resource "aws_security_group" "common" {
  name        = "a-isg-steve-dev-ane2-common01"
  description = "Common security group"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "a-isg-steve-dev-ane2-common01"
    }
  )
}

# ============================================================
# Interface VPC Endpoint Security Group
# EC2 / STS / EKS Auth / CloudWatch / ELB / X-Ray
# ============================================================

resource "aws_security_group" "vpce" {
  name        = "${local.provider}-isg-${local.project}-${local.environment}-${local.region_code}-vpce01"
  description = "Security group for interface VPC endpoints"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-isg-${local.project}-${local.environment}-${local.region_code}-vpce01"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "vpce_https" {
  security_group_id = aws_security_group.vpce.id

  cidr_ipv4   = var.vpc_cidr
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  description = "Allow HTTPS from VPC"
}

# ============================================================
# ECR Interface VPC Endpoint Security Group
# Separate SG for possible on-premises access
# ============================================================

resource "aws_security_group" "vpce_ecr" {
  name        = "${local.provider}-isg-${local.project}-${local.environment}-${local.region_code}-vpce-ecr01"
  description = "Security group for ECR interface VPC endpoints"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-isg-${local.project}-${local.environment}-${local.region_code}-vpce-ecr01"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "vpce_ecr_https" {
  security_group_id = aws_security_group.vpce_ecr.id

  cidr_ipv4   = var.vpc_cidr
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  description = "Allow HTTPS from VPC"
}

# ============================================================
# Private NLB
# ============================================================

resource "aws_security_group" "private_nlb" {
  name        = "${local.provider}-esg-${local.project}-${local.environment}-${local.region_code}-nlb01"
  description = "Security group for private NLB"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-esg-${local.project}-${local.environment}-${local.region_code}-nlb01"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "private_nlb" {
  security_group_id = aws_security_group.private_nlb.id

  cidr_ipv4   = var.vpc_cidr
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP from VPC"
}

resource "aws_vpc_security_group_egress_rule" "private_nlb" {
  security_group_id = aws_security_group.private_nlb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic"
}

# ============================================================
# ALB
# ============================================================

resource "aws_security_group" "alb" {
  name        = "${local.provider}-esg-${local.project}-${local.environment}-${local.region_code}-alb01"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-esg-${local.project}-${local.environment}-${local.region_code}-alb01"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "alb" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = var.vpc_cidr
  from_port   = var.alb_listener_port
  to_port     = var.alb_listener_port
  ip_protocol = "tcp"

  description = "Allow traffic to ALB"
}

resource "aws_vpc_security_group_egress_rule" "alb" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic"
}
