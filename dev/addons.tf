/*# ============================================================
# Default EKS Add-ons
# Managed explicitly by Terraform
# ============================================================

resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = aws_eks_cluster.steve_cluster.name
  addon_name               = "vpc-cni"
  service_account_role_arn = aws_iam_role.eks_vpccni.arn

  depends_on = [
    aws_iam_role_policy_attachment.eks_vpccni
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.steve_cluster.name
  addon_name   = "coredns"

  depends_on = [
    aws_eks_node_group.steve_node_group
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.steve_cluster.name
  addon_name   = "kube-proxy"

  depends_on = [
    aws_eks_node_group.steve_node_group
  ]
}

# ============================================================
# Additional EKS Add-ons
# Installed explicitly when required
# ============================================================

resource "aws_eks_addon" "cert_manager" {
  cluster_name = aws_eks_cluster.steve_cluster.name
  addon_name   = "cert-manager"

  depends_on = [
    aws_eks_node_group.steve_node_group
  ]
}

resource "aws_eks_addon" "metrics_server" {
  cluster_name = aws_eks_cluster.steve_cluster.name
  addon_name   = "metrics-server"

  depends_on = [
    aws_eks_node_group.steve_node_group
  ]
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.steve_cluster.name
  addon_name   = "eks-pod-identity-agent"

  depends_on = [
    aws_eks_node_group.steve_node_group
  ]
}

resource "aws_eks_addon" "node_monitoring_agent" {
  cluster_name = aws_eks_cluster.steve_cluster.name
  addon_name   = "eks-node-monitoring-agent"

  depends_on = [
    aws_eks_node_group.steve_node_group
  ]
}

resource "aws_eks_addon" "cloudwatch_observability" {
  cluster_name = aws_eks_cluster.steve_cluster.name
  addon_name   = "amazon-cloudwatch-observability"

  pod_identity_association {
    role_arn        = aws_iam_role.eks_cloudwatch.arn
    service_account = "cloudwatch-agent"
  }

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.eks_cloudwatch
  ]
}

resource "aws_eks_addon" "external_dns" {
  cluster_name = aws_eks_cluster.steve_cluster.name
  addon_name   = "external-dns"

  pod_identity_association {
    role_arn        = aws_iam_role.eks_external_dns.arn
    service_account = "external-dns"
  }

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.eks_external_dns
  ]
}*/
