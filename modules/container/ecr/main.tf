locals {
  repository_name = var.namespace != "" ? "${var.namespace}/${var.name}" : var.name
}

resource "aws_ecr_repository" "this" {
  name = local.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key = var.kms_key
  }

  tags = merge(var.tags, {
    Name = local.repository_name
  })
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.create_lifecycle_policy ? 1 : 0
  repository = aws_ecr_repository.this.name

  policy = var.lifecycle_policy_json != null ? var.lifecycle_policy_json : jsonencode({
    rules = [
        {
          rulePriority = 1 
          description = "Keep last 5 untagged images"
          selection = {
            tagStatus = "untagged"
            countType = "imageCountMoreThan"
            countNumber = 5
          }
          action = {
            type = "expire"
          }
        }
    ]
  })
}