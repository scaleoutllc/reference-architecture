
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
  type    = list(string)
  default = []
}

variable "private_subnets" {
  type    = list(string)
  default = []
}

variable "transit_gateway_subnets" {
  type = list(string)
}

variable "internet_gateway" {
  type    = bool
  default = false
}

variable "nat_gateways" {
  type    = bool
  default = false
}
