variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "common_tags" {
  description = "Common resource tags"
  type = map(string)
  default = {}
}

variable "subnets" {
  description = "Subnet configurations"

  type = map(object({
    name = string
    cidr_block = string
    availability_zone = string
    map_public_ip_on_launch = optional(bool, false)
    tags = optional(map(string), {})
  }))
}