variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "elb_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))

  default = {
    elb_a = {
      cidr_block        = "10.0.11.0/24"
      availability_zone = "ap-northeast-2a"
      name              = "a-isnet-steve-dev-ane2-elb01"
    }

    elb_c = {
      cidr_block        = "10.0.12.0/24"
      availability_zone = "ap-northeast-2c"
      name              = "a-isnet-steve-dev-ane2-elb02"
    }
  }

  description = "ELB subnet configuration"
}

variable "enable_imds_v2" {
  description = "Whether to enable IMDSv2"
  type        = bool
  default     = true
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP"
  type        = bool
  default     = true
}

variable "eks_node_ami_id" {
  description = "Golden AMI ID for EKS worker nodes"
  type        = string
}

variable "eks_node_instance_type" {
  description = "Instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "eks_node_volume_size" {
  description = "Root EBS volume size"
  type        = number
  default     = 20
}

# ELB variable
variable "nlb_tg_port" {
  description = "NLB target group port"
  type        = number
  default     = 80
}

variable "nlb_tg_protocol" {
  description = "NLB target group protocol"
  type        = string
  default     = "TCP"
}

variable "nlb_tg_health_check_protocol" {
  description = "NLB target group health check protocol"
  type        = string
  default     = "HTTP"
}

variable "nlb_tg_health_check_path" {
  description = "NLB target group health check path"
  type        = string
  default     = "/health"
}

variable "nlb_tg_health_check_interval" {
  description = "NLB target group health check interval"
  type        = number
  default     = 30
}

variable "prefix_list_name" {
  type        = string
  description = "Name of the managed prefix list"
  default     = "test-prefix-list"
}

variable "prefix_list_max_entries" {
  type        = number
  description = "Maximum number of entries in the prefix list"
  default     = 10
}

variable "prefix_list_entries" {
  type = list(object({
    cidr        = string
    description = string
  }))

  description = "Entries for the managed prefix list"

  default = [
    {
      cidr        = "172.16.10.0/24"
      description = "test-network-01"
    },
    {
      cidr        = "172.16.20.0/24"
      description = "test-network-02"
    }
  ]
}

variable "bastion_ami_id" {
  type        = string
  default     = "ami-068b9b022a1cc74f1"
  description = "AMI ID for bastion"
}

variable "nlb_scheme" {
  type        = bool
  default     = true
  description = "NLB scheme: internal or internet-facing"
}

variable "nlb_listner_port" {
  type        = number
  default     = 80
  description = "NLB listner port"

}

variable "nlb_listner_protocol" {
  type        = string
  default     = "TCP"
  description = "NLB listener protocol"

}

variable "nlb_cross_zone_enabled" {
  type        = bool
  default     = false
  description = "Enable cross-zone load balancing"

}

# ALB Variable
variable "alb_scheme" {
  type        = string
  default     = "internal"
  description = "ALB scheme: internal or internet-facing"
}

variable "alb_listener_port" {
  type        = number
  default     = 80
  description = "ALB listner port"

}

variable "alb_listener_protocol" {
  type        = string
  default     = "HTTP"
  description = "ALB listener protocol"

}

variable "alb_tg_port" {
  type        = number
  default     = 80
  description = "ALB target group port"
}

variable "alb_tg_protocol" {
  type        = string
  default     = "HTTP"
  description = "ALB target group protocol"
}

variable "alb_health_check_path" {
  type        = string
  default     = "/"
  description = "ALB target group health check path"
}

# EKS Cluster variable
variable "eks_cluster_name" {
  type        = string
  default     = "a-eks-steve-dev-ane2-cluster01"
  description = "EKS cluster name"
}

variable "eks_cluster_version" {
  type        = string
  default     = "1.36"
  description = "Kubernetes version for EKS cluster"
}

variable "eks_endpoint_access" {
  type        = string
  default     = "private"
  description = "EKS endpoint access mode: private, public, or public-and-private"
}

variable "eks_authentication_mode" {
  type        = string
  default     = "API"
  description = "EKS cluster authentication mode"
}

variable "eks_bootstrap_cluster_admin" {
  type        = bool
  default     = true
  description = "Enable cluster creator administrator permissions"
}

variable "eks_upgrade_support_type" {
  type        = string
  default     = "STANDARD"
  description = "EKS Kubernetes version support policy"
}

variable "eks_deletion_protection" {
  type        = bool
  default     = false
  description = "Enable EKS cluster deletion protection"
}

variable "eks_control_plane_scaling_tier" {
  type        = string
  default     = "standard"
  description = "EKS control plane scaling tier"
}

variable "eks_zonal_shift_enabled" {
  type        = bool
  default     = false
  description = "Enable ARC zonal shift for EKS cluster"
}

variable "eks_cluster_log_types" {
  type = list(string)

  default = [
    "api",
    "audit",
    "authenticator"
  ]

  description = "Enabled EKS control plane log types"
}

# EKS NodeGroup variable
variable "eks_node_group_name" {
  type        = string
  default     = "a-eks-steve-dev-ane2-node01"
  description = "EKS managed node group name"
}

variable "eks_node_capacity_type" {
  type        = string
  default     = "SPOT"
  description = "EKS managed node group capacity type"
}

variable "eks_node_instance_types" {
  type        = list(string)
  default     = ["t3.small"]
  description = "EC2 instance types for EKS managed node group"
}

variable "eks_describe_size" {
  type        = number
  default     = 2
  description = "Desired number of EKS worker nodes"
}

variable "eks_node_min_size" {
  type        = number
  default     = 2
  description = "Minimum number of EKS worker nodes"
}

variable "eks_node_max_size" {
  type        = number
  default     = 2
  description = "Max number of EKS worker nodes"
}

variable "eks_service_ipv4_cidr" {
  type        = string
  default     = "172.20.0.0/16"
  description = "IPv4 CIDR block for Kubernetes services in the EKS cluster"
}

# RDS
variable "aurora_cluster_identifier" {
  type        = string
  default     = "a-rds-steve-dev-ane2-aurora01"
  description = "Aurora MySQL cluster identifier"
}

variable "aurora_engine_version_mode" {
  type        = string
  default     = "latest"
  description = "Aurora MySQL engine version selection mode: latest or fixed"

  validation {
    condition = contains(
      ["latest", "fixed"],
      var.aurora_engine_version_mode
    )

    error_message = "aurora_engine_version_mode must be latest or fixed."
  }
}

variable "aurora_engine_version" {
  type        = string
  default     = "null"
  description = "Fixed Aurora MySQL engine version when version mode is fixed"
}

variable "aurora_instance_class" {
  type        = string
  default     = "db.t3.medium"
  description = "Aurora MySQL DB instance class"
}

variable "aurora_master_username" {
  type        = string
  default     = "admin"
  description = "Aurora MySQL master username"
}

variable "aurora_manage_master_user_password" {
  type        = bool
  default     = true
  description = "Whether Aurora manages the master user password in AWS Secrets Manager"
}

variable "aurora_mysql_port" {
  type        = number
  default     = 3306
  description = "Aurora MySQL port"
}

variable "aurora_replica_count" {
  type        = number
  default     = 0
  description = "Number of Aurora read replicas"
}

variable "aurora_backup_retention_period" {
  type        = number
  default     = 7
  description = "Aurora automated backup retention period in days"
}

variable "aurora_storage_encrypted" {
  type        = bool
  default     = true
  description = "Whether Aurora storage encryption is enabled"
}

variable "aurora_auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Whether automatic minor version upgrades are enabled"
}

variable "aurora_deletion_protection" {
  type        = bool
  default     = false
  description = "Whether Aurora deletion protection is enabled"
}

variable "aurora_skip_final_snapshot" {
  type        = bool
  default     = true
  description = "Whether to skip the final snapshot when deleting the Aurora cluster"
}

variable "aurora_copy_tags_to_snapshot" {
  type        = bool
  default     = true
  description = "Whether tags are copied to Aurora snapshots"
}

variable "aurora_apply_immediately" {
  type        = bool
  default     = false
  description = "Whether Aurora modifications are applied immediately"
}

variable "aurora_cloudwatch_log_exports" {
  type = list(string)

  default = [
    "general"
  ]

  description = "Aurora MySQL logs exported to CloudWatch Logs"
}

variable "rds_proxy_enabled" {
  type        = bool
  default     = false
  description = "Whether RDS Proxy is enabled"
}

variable "aurora_iam_database_authentication_enabled" {
  type        = bool
  default     = false
  description = "Whether IAM database authentication is enabled"
}