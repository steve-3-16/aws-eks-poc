variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "subnet_ids" {
  description = "Subnet IDs by key"
  type = map(string)
}

variable "common_tags" {
  description = "Common resource tags"
  type = map(string)
  default = {}
}

variable "route_tables" {
  description = "Route table configurations"
  
  type = map(object({
    name = string
    tags = optional(map(string), {})
  })) 
}

variable "route_table_associations" {
  description = "Subnet to Route Table associations"

  type = map(object({
    subnet_key      = string
    route_table_key = string
  }))

  default = {}
}

variable "routes" {
  description = "Route configurations"

  type = map(object({
    route_table_key = string

    # Destination
    destination_cidr_block = optional(string)
    destination_ipv6_cidr_block = optional(string)
    destination_prefix_list_id = optional(string)
    
    # Target
    gateway_id = optional(string)
    nat_gateway_id = optional(string)
    transit_gateway_id = optional(string)
    vpc_peering_connection_id = optional(string)
    network_interface_id = optional(string)
    instance_id = optional(string)
    vpc_endpoint_id = optional(string)
    local_gateway_id = optional(string)
    carrier_gateway_id = optional(string)
    egress_only_gateway_id = optional(string)
  }))

  default = {}

  validation {
    condition = alltrue([
      for route in values(var.routes) :
      length(compact([
        route.destination_cidr_block,
        route.destination_ipv6_cidr_block,
        route.destination_prefix_list_id
      ])) == 1
    ])
    error_message = "Each route must specify exactly one destination."
  }

validation {
    condition = alltrue([
      for route in values(var.routes) :
      length(compact([
        route.gateway_id,
        route.nat_gateway_id,
        route.transit_gateway_id,
        route.vpc_peering_connection_id,
        route.network_interface_id,
        route.instance_id,
        route.vpc_endpoint_id,
        route.local_gateway_id,
        route.carrier_gateway_id,
        route.egress_only_gateway_id
      ])) == 1
    ])

    error_message = "Each route must specify exactly one target."
}
}