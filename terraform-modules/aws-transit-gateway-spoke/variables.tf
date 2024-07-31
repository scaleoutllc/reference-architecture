variable "name" {
  type = string
}

variable "transit_gateway" {
  type = object({
    id                       = string
    egress_vpc_attachment_id = string
  })
}

variable "vpc" {
  type = object({
    id                        = string
    cidr                      = string
    attach_subnet_ids         = list(string)
    egressing_route_table_ids = list(string)
  })
}

