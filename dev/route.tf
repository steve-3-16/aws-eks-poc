resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "a-irot-steve-dev-ane2-pub01"
  }
}

resource "aws_route_table" "public_c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "a-irot-steve-dev-ane2-pub02"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "a-irot-steve-dev-ane2-pri01"
  }
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "a-irot-steve-dev-ane2-pri02"
  }
}

resource "aws_route_table" "compute" {
  count = 2

  vpc_id = aws_vpc.main.id

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

# Private subnet association
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private["private_a"].id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private["private_c"].id
  route_table_id = aws_route_table.private_c.id
}

# Compute subnet association
resource "aws_route_table_association" "compute" {
  count = 2

  subnet_id      = aws_subnet.compute[count.index].id
  route_table_id = aws_route_table.compute[count.index].id
}

# Bastion public subnet association
resource "aws_route_table_association" "bastion_public" {
  subnet_id      = aws_subnet.public["public_a"].id
  route_table_id = aws_route_table.public_a.id
}
