resource "aws_nat_gateway" "name" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["public_a"].id

  tags = {
    Name = "a-ntg-steve-dev-ane2-aegis01"
  }

  depends_on = [aws_internet_gateway.main]
}
