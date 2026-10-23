output "route_table_ids" {
  description = "Route table IDs by key"

  value = {
    for key, rt in aws_route_table.this :
    key => rt.id
  }
}