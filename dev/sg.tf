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



resource "aws_security_group" "aurora_mysql" {
  name        = "${local.provider}-isg-${local.project}-${local.environment}-${local.region_code}-aurora-mysql01"
  description = "Security group for Aurora MySQL"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-isg-${local.project}-${local.environment}-${local.region_code}-aurora-mysql01"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "aurora_mysql" {
  security_group_id = aws_security_group.aurora_mysql.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = var.aurora_mysql_port
  to_port           = var.aurora_mysql_port
  ip_protocol       = "tcp"
  description       = "Allow MySQL access from VPC"
}

# ============================================================
# ALB Security Group
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

resource "aws_vpc_security_group_ingress_rule" "alb_listener" {
  for_each = var.alb_listeners

  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = var.vpc_cidr
  from_port   = each.value.port
  to_port     = each.value.port
  ip_protocol = "tcp"

  description = "Allow ALB listener port ${each.value.port}"
}

resource "aws_vpc_security_group_egress_rule" "alb" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic"
}

resource "aws_security_group" "web" {
  name        = "${local.provider}-isg-${local.project}-${local.environment}-${local.region_code}-web01"
  description = "Security group for Web EC2"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-isg-${local.project}-${local.environment}-${local.region_code}-web01"
    }
  )
}

# Allow HTTP traffic from ALB
resource "aws_vpc_security_group_ingress_rule" "web_http" {
  security_group_id = aws_security_group.web.id

  referenced_security_group_id = aws_security_group.alb.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP from ALB"
}

# Allow outbound traffic
resource "aws_vpc_security_group_egress_rule" "web" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic"
}

# OpenVPN Security Group
resource "aws_security_group" "openvpn" {
  name        = "${local.provider}-sg-${local.project}-${local.environment}-${local.region_code}-openvpn"
  description = "OpenVPN Security Group"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags, {
      Name = "${local.provider}-sg-${local.project}-${local.environment}-${local.region_code}-openvpn"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "openvpn_udp" {
  security_group_id = aws_security_group.openvpn.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 1194
  to_port           = 1194
  ip_protocol       = "udp"
  description       = "OpenVPN UDP 1194"
}

resource "aws_vpc_security_group_ingress_rule" "openvpn_ssh" {
  security_group_id = aws_security_group.openvpn.id

  cidr_ipv4   = "182.231.63.14/32"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "SSH access from my PC"
}

resource "aws_vpc_security_group_egress_rule" "openvpn" {
  security_group_id = aws_security_group.openvpn.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow outbound"
}

module "test_sg" {
  source      = "../modules/security/security-group"
  name        = "test_sg"
  description = "Terraform module test security group"
  vpc_id      = "vpc-01c70d52ff6c3144e"

  ingress = [
    { from_port = 22, to_port = 22, ip_protocol = "tcp", cidr_ipv4 = "0.0.0.0/0", description = "SSH access" },
    { from_port = 443, to_port = 443, ip_protocol = "tcp", cidr_ipv4 = "0.0.0.0/0", description = "HTTPS access" }
  ]

  egress = [
    { from_port = 0, to_port = 0, ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0", description = "Allow all outbound" }
  ]

  tags = {
    Name        = "test-sg"
    Environment = "dev"
    project     = "eks-poc"
  }
}