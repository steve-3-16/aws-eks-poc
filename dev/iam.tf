resource "aws_iam_role" "bastion" {
  name = "a-iamro-steve-dev-ane2-bastion01"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "a-iamro-steve-dev-ane2-bastion01"
  }
}

resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "a-iamip-steve-dev-ane2-bastion01"
  role = aws_iam_role.bastion.name
}

# EKS Cluster Role, Policy
resource "aws_iam_role" "eks_cluster" {
  name = "${local.provider}-iam-ro-${local.project}-${local.environment}-${local.region_code}-eks-cluster01"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-iamro-${local.project}-${local.environment}-${local.region_code}-eks-cluster01"
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS Node Role, Policy
resource "aws_iam_role" "eks_node" {
  name = "${local.provider}-iamro-${local.project}-${local.environment}-${local.region_code}-eks-node01"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-iamro-${local.project}-${local.environment}-${local.region_code}-eks-node01"
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_node_worker" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_ecr" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

/*# EKS VPC CNI Role, Policy
data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.steve_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.steve_cluster.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-oidc-${local.project}-${local.environment}-${local.region_code}-eks01"
    }
  )
}*/

/*resource "aws_iam_role" "eks_vpccni" {
  name        = "${local.provider}-iamro-${local.project}-${local.environment}-${local.region_code}-eks-vpccni01"
  description = "IAM role for EKS VPC CNI add-on using IRSA"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "${replace(aws_eks_cluster.steve_cluster.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"

            "${replace(aws_eks_cluster.steve_cluster.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-node"
          }
        }
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-iamro-${local.project}-${local.environment}-${local.region_code}-eks-vpccni01"
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_vpccni" {
  role       = aws_iam_role.eks_vpccni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}*/

resource "aws_iam_role" "eks_cloudwatch" {
  name        = "${local.provider}-iamro-${local.project}-${local.environment}-${local.region_code}-eks-cloudwatch01"
  description = "IAM role for EKS CloudWatch Observability add-on using Pod Identity"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-iamro-${local.project}-${local.environment}-${local.region_code}-eks-cloudwatch01"
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_cloudwatch" {
  role       = aws_iam_role.eks_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role" "eks_external_dns" {
  name        = "${local.provider}-iamro-${local.project}-${local.environment}-${local.region_code}-eks-externaldns01"
  description = "IAM role for EKS External DNS add-on using Pod Identity"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-iamro-${local.project}-${local.environment}-${local.region_code}-eks-externaldns01"
    }
  )
}

resource "aws_iam_policy" "eks_external_dns" {
  name        = "${local.provider}-iampo-${local.project}-${local.environment}-${local.region_code}-eks-externaldns01"
  description = "IAM policy for EKS External DNS"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "route53:ChangeResourceRecordSets"
        ]

        Resource = "arn:aws:route53:::hostedzone/*"
      },
      {
        Effect = "Allow"

        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_external_dns" {
  role       = aws_iam_role.eks_external_dns.name
  policy_arn = aws_iam_policy.eks_external_dns.arn
}
