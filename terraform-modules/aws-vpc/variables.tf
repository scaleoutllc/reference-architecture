
variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "transit_gateway_subnets" {
  type = list(string)
}

variable "internet_gateway" {
  type = bool
}

variable "nat_gateways" {
  type = bool
}

variable "transit_gateway" {
  type = bool
}
