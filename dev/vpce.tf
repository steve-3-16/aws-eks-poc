resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.compute[0].id,
    aws_route_table.compute[1].id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "a-vpce-steve-dev-ane2-s3"
    }
  )
}
