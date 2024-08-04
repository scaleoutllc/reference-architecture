variable "accepter" {
  type = object({
    name               = string
    cidr               = string
    transit_gateway_id = string
    route_table_id     = string
  })
}

variable "peer" {
  type = object({
    name               = string
    cidr               = string
    transit_gateway_id = string
    route_table_id     = string
    account_id         = string
    region             = string
  })
}
