resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.public_a.id,
    aws_route_table.public_c.id,
    aws_route_table.compute[0].id,
    aws_route_table.compute[1].id,
    aws_route_table.vpce[0].id,
    aws_route_table.vpce[1].id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "a-vpce-steve-dev-ane2-s3"
    }
  )
}

# # ECR 관리/API 통신
# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.ap-northeast-2.ecr.api"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   subnet_ids = [
#     aws_subnet.vpce[0].id,
#     aws_subnet.vpce[1].id
#   ]

#   security_group_ids = [
#     aws_security_group.vpce_ecr.id
#   ]

#   tags = merge(local.common_tags, {
#     Name = "${local.provider}-vpce-${local.project}-${local.environment}-${local.region_code}-ecr-api"
#   })
# }

# # Docker 이미지 Push/Pull 통신
# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.ap-northeast-2.ecr.dkr"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   subnet_ids = [
#     aws_subnet.vpce[0].id,
#     aws_subnet.vpce[1].id
#   ]

#   security_group_ids = [
#     aws_security_group.vpce_ecr.id
#   ]

#   tags = merge(local.common_tags, {
#     Name = "${local.provider}-vpce-${local.project}-${local.environment}-${local.region_code}-ecr-dkr"
#   })
# }

# # AWS 임시 자격증명/Role 인증 관련 통신
# resource "aws_vpc_endpoint" "sts" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.ap-northeast-2.sts"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   subnet_ids = [
#     aws_subnet.vpce[0].id,
#     aws_subnet.vpce[1].id
#   ]

#   security_group_ids = [
#     aws_security_group.vpce_ecr.id
#   ]

#   tags = merge(local.common_tags, {
#     Name = "${local.provider}-vpce-${local.project}-${local.environment}-${local.region_code}-sts"
#   })
# }
