variable "name" {
  description = "Security Group name"
  type = string
}

variable "description" {
  description = "Security Group description"
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "ingress" {
  description = "Ingress rules"
  
  type = list(object({
    from_port = number
    to_port = number
    ip_protocol = string
    cidr_ipv4 = optional(string)
    referenced_security_group_id = optional(string)
    description = optional(string) 
  }))
  
  default = []
}

variable "egress" {
  description = "Engress rules"
  
  type = list(object({
    from_port = number
    to_port = number
    ip_protocol = string
    cidr_ipv4 = optional(string)
    referenced_security_group_id = optional(string)
    description = optional(string) 
  }))
  
  default = []
}

variable "tags" {
  type = map(string)
  default = {}
}