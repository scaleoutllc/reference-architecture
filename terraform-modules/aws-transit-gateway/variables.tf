variable "name" {
  type = string
}

variable "asn" {
  type = string
}

variable "egress_vpc" {
  type = object({
    id                     = string
    name                   = string
    transit_subnet_ids     = list(string)
    public_route_table_ids = list(string)
  })
}
