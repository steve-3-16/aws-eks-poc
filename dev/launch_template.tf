resource "aws_launch_template" "eks_node" {
  name_prefix = "${local.eks_node_lt_name}-"

  image_id      = var.eks_node_ami_id
  instance_type = var.eks_node_instance_type

  #default_version = 2

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  block_device_mappings {
    device_name = "/dev/xvda"


    ebs {
      volume_type           = "gp3"
      volume_size           = var.eks_node_volume_size
      encrypted             = true
      delete_on_termination = true
    }
  }
}
