resource "aws_ecr_repository" "app" {
  name                 = "${local.provider}-ecr-${local.project}-${local.environment}-${local.region_code}-app01"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(local.common_tags, {
    Name = "${local.provider}-ecr-${local.project}-${local.environment}-${local.region_code}-app01"
  })
}

module "ecr_app" {
  source = "../modules/container/ecr"
  name   = "app"

  tags = {
    Environment = "dev"
  }
}