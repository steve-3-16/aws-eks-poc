variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))

  description = "Private subnet configuration"

  default = {
    private_a = {
      cidr_block        = "10.0.11.0/24"
      availability_zone = "ap-northeast-2a"
      name              = "a-isnet-steve-dev-ane2-compute01"
    }

    private_c = {
      cidr_block        = "10.0.12.0/24"
      availability_zone = "ap-northeast-2c"
      name              = "a-isnet-steve-dev-ane2-compute02"
    }
  }
}
