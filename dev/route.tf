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
