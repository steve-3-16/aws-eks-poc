resource "aws_security_group" "this" {
  name = var.name
  description = var.description
  vpc_id = var.vpc_id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = {
    for idx, rule in var.ingress :
    idx => rule
  }

  security_group_id = aws_security_group.this.id

  from_port = each.value.from_port
  to_port = each.value.to_port
  ip_protocol = each.value.ip_protocol

  cidr_ipv4 = try(each.value.cidr_ipv4, null)

  referenced_security_group_id = try(
    each.value.referenced_security_group_id,
    null
  )

  description = try(each.value.description, null)
}

resource "aws_vpc_security_group_egress_rule" "this" {
# for 변수 in 대상 : 결과  
  for_each = {
    for idx, rule in var.egress : #var.egress 리스트에서 idx(인덱스), rule(각 규칙 데이터)을 하나씩 추출
    idx => rule  # 추출한 데이터를 idx => rule 형태의 map으로 변환하여 for_each 반복 생성에 사용
  }

  security_group_id = aws_security_group.this.id

  from_port = each.value.from_port
  to_port = each.value.to_port
  ip_protocol = each.value.ip_protocol

  cidr_ipv4 = try(each.value.cidr_ipv4, null)

  referenced_security_group_id = try(
    each.value.referenced_security_group_id,
    null
  )

  description = try(each.value.description, null)
}