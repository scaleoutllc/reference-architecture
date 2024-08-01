variable "name" {
  type = string
}

variable "transit_gateway" {
  type = object({
    id                                = string
    egress_vpc_public_route_table_ids = list(string)
    inbound_route_table_id            = string
    outbound_route_table_id           = string
  })
}

variable "spoke_vpc" {
  type = object({
    id = string
    layout = object({
      cidr = string
    })
    private_route_table_ids = list(string)
    transit_subnet_ids      = list(string)
  })
}
