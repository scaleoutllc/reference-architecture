variable "name" {
  type = string
}

variable "accepter" {
  type = object({
    cidr               = string
    transit_gateway_id = string
    route_table_id     = string
  })
}

variable "peer" {
  type = object({
    cidr               = string
    transit_gateway_id = string
    route_table_id     = string
    account_id         = string
    region             = string
  })
}
