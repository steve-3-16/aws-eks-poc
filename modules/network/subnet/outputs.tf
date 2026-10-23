output "subnet_ids" {
  description = "Subnet IDs by key"

  value = {
    for key, subnet in aws_subnet.this :
    key => subnet.id
  }
}