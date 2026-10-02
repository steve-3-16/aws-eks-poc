output "import_test_sg_id" {
  description = "Import test security group ID"
  value       = aws_security_group.import_test.id
}

data "aws_security_group" "import02" {
  name = "a-isg-steve-dev-ane2-import02"
}

output "sg_id" {
  value = data.aws_security_group.import02.id
}

output "eks_node_launch_template_id" {
  description = "EKS node Launch Template ID"
  value       = aws_launch_template.eks_node.id
}

output "eks_node_launch_template_latest_version" {
  description = "Latest Launch Template version"
  value       = aws_launch_template.eks_node.latest_version
}

output "prefix_list_id" {
  description = "ID of the managed prefix list"
  value       = aws_ec2_managed_prefix_list.test.id
}
