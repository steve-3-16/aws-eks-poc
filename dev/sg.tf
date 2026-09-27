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

# Ingress : 203.0.113.10 → Bastion SSH 22
resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion.id

  referenced_security_group_id = aws_security_group.import_test.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
}

# Egress : Bastion → 198.51.100.20 HTTPS 443
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
