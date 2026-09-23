resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "a-eip-steve-dev-ane2-nat01"
  }

}
