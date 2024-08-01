variable "name" {
  type = string
}

variable "egress_vpc" {
  type = object({
    id                     = string
    transit_subnet_ids     = list(string)
    public_route_table_ids = list(string)
  })
}
