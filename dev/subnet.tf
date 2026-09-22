locals {
  public_subnets = {
    public_a = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-northeast-2a"
      name              = "a-isnet-steve-dev-ane2-elb01"
    }

    public_c = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "ap-northeast-2c"
      name              = "a-isnet-steve-dev-ane2-elb02"
    }
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = each.value.name
  }
}
