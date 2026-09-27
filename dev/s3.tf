resource "aws_s3_bucket" "poc" {
  bucket        = "sunggwan-steve-dev-ane2-poc"
  force_destroy = false

  tags = merge(
    local.common_tags,
    {
      Name = "sunggwan-steve-dev-ane2-poc"
    }
  )
}

# Versioning
resource "aws_s3_bucket_versioning" "poc" {
  bucket = aws_s3_bucket.poc.id

  versioning_configuration {
    status = "Enabled" # Enabled: 활성화 | Suspended: 중지 | Disabled: 비활성화
  }
}

#  SSE-S3 (Server-Side Encryption with Amazon S3 managed keys)
resource "aws_s3_bucket_server_side_encryption_configuration" "poc" {
  bucket = aws_s3_bucket.poc.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "poc" {
  bucket = aws_s3_bucket.poc.id

  block_public_acls       = true # Public ACL 설정 차단
  ignore_public_acls      = true # 기존 Public ACL도 무시
  block_public_policy     = true # Public Bucket Policy 차단
  restrict_public_buckets = true # Public Policy가 있어도 공개 접근 제한
}

# Lifecycle 
resource "aws_s3_bucket_lifecycle_configuration" "poc" {
  bucket = aws_s3_bucket.poc.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days           = 7 # 7일 후 삭제
      newer_noncurrent_versions = 5 # 이전 버전 5개 보관
    }
  }
}
