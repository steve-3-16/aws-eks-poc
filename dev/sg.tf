resource "aws_security_group" "import_test" {
  name        = "a-isg-steve-dev-ane2-import01"
  vpc_id      = aws_vpc.main.id
  description = "a-isg-steve-dev-ane2-import01"
  tags = {
    Name = "a-isg-steve-dev-ane2-import01"
  }
}
