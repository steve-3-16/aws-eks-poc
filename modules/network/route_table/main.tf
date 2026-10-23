# Route Table 생성
resource "aws_route_table" "this" {
  for_each = var.route_tables

  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    each.value.tags,
    {
      Name = each.value.name  
    }
  )
}

# Subnet과 Route Table 연결
resource "aws_route_table_association" "this" {
  for_each = var.route_table_associations

  subnet_id      = var.subnet_ids[each.value.subnet_key]
  route_table_id = aws_route_table.this[each.value.route_table_key].id
}

# Routing 경로 설정
resource "aws_route" "this" {
  for_each = var.routes

  route_table_id = aws_route_table.this[each.value.route_table_key].id
  destination_cidr_block = each.value.destination_cidr_block
  gateway_id = each.value.gateway_id
}