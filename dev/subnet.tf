locals {
  public_subnets = {
    public_a = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-northeast-2a"
      name              = "a-isnet-steve-dev-ane2-pub01"
    }

    public_c = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "ap-northeast-2c"
      name              = "a-isnet-steve-dev-ane2-pub02"
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

resource "aws_subnet" "elb" {
  for_each = var.elb_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = each.value.name
  }
}

resource "aws_subnet" "compute" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${21 + count.index}.0/24"
  availability_zone       = count.index == 0 ? "ap-northeast-2a" : "ap-northeast-2c"
  map_public_ip_on_launch = false

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-isnet-${local.project}-${local.environment}-${local.region_code}-compute0${count.index + 1}"
    }
  )
}

resource "aws_subnet" "vpce" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${41 + count.index}.0/24"
  availability_zone       = count.index == 0 ? "ap-northeast-2a" : "ap-northeast-2c"
  map_public_ip_on_launch = false

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-isnet-${local.project}-${local.environment}-${local.region_code}-vpce0${count.index + 1}"
    }
  )
}

# DB Subnet
resource "aws_subnet" "db" {
  count = 2

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${31 + count.index}.0/24"
  availability_zone = count.index == 0 ? "ap-northeast-2a" : "ap-northeast-2c"

  tags = merge(local.common_tags, {
    Name = "${local.provider}-isnet-${local.project}-${local.environment}-${local.region_code}-db0${count.index + 1}"
  })
}


# TGW Subnet
resource "aws_subnet" "tgw" {
  count = 2

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${61 + count.index}.0/24"
  availability_zone = count.index == 0 ? "ap-northeast-2a" : "ap-northeast-2c"

  tags = merge(local.common_tags, {
    Name = "${local.provider}-isnet-${local.project}-${local.environment}-${local.region_code}-tgw0${count.index + 1}"
  })
}
