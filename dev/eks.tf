/*# EKS Cluster
resource "aws_eks_cluster" "steve_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.eks_cluster_version

  enabled_cluster_log_types = var.eks_cluster_log_types
  deletion_protection       = var.eks_deletion_protection

  access_config {
    authentication_mode                         = var.eks_authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.eks_bootstrap_cluster_admin
  }


  upgrade_policy {
    support_type = var.eks_upgrade_support_type
  }

  control_plane_scaling_config {
    tier = var.eks_control_plane_scaling_tier
  }

  zonal_shift_config {
    enabled = var.eks_zonal_shift_enabled
  }

  vpc_config {
    subnet_ids = [
      aws_subnet.eks[0].id,
      aws_subnet.eks[1].id
    ]

    endpoint_private_access = contains(
      ["private", "public-and-private"],
      var.eks_endpoint_access
    )

    endpoint_public_access = contains(
      ["public", "public-and-private"],
      var.eks_endpoint_access
    )
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.eks_service_ipv4_cidr
  }

  tags = merge(
    local.common_tags,
    {
      Name = var.eks_cluster_name
    }
  )

  depends_on = [aws_iam_role_policy_attachment.eks_cluster]
}

/*# NodeGroup
resource "aws_eks_node_group" "steve_node_group" {
  cluster_name    = aws_eks_cluster.steve_cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.eks_node.arn

  subnet_ids = [
    aws_subnet.eks[0].id,
    aws_subnet.eks[1].id
  ]

  capacity_type  = var.eks_node_capacity_type
  instance_types = var.eks_node_instance_types

  scaling_config {
    desired_size = var.eks_describe_size
    min_size     = var.eks_node_min_size
    max_size     = var.eks_node_max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = merge(
    local.common_tags,
    {
      Name = var.eks_node_group_name
    }
  )

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_worker,
    aws_iam_role_policy_attachment.eks_node_ecr,
    aws_eks_addon.vpc_cni
  ]
}*/
