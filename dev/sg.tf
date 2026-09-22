resource "aws_security_group" "import_test" {
  name   = "a-isg-steve-dev-ane2-import01"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "a-isg-steve-dev-ane2-import01"
  }
}
