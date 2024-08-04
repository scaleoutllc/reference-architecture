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
    id                      = string
    name                    = string
    cidr                    = string
    private_route_table_ids = list(string)
    transit_subnet_ids      = list(string)
  })
}
