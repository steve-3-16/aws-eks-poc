resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "a-igw-steve-dev-ane2-01"
  }
}
