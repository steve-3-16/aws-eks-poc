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
