resource "aws_ec2_managed_prefix_list" "test" {
  name           = var.prefix_list_name
  address_family = "IPv4"
  max_entries    = var.prefix_list_max_entries

  dynamic "entry" {
    for_each = var.prefix_list_entries

    content {
      cidr        = entry.value.cidr
      description = entry.value.description
    }
  }

  tags = {
    Name = var.prefix_list_name
  }
}
