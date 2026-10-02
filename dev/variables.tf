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

  description = "ELB subnet configuration"

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

