
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

variable "public_subnet_tags" {
  type    = map(any)
  default = {}
}

variable "private_subnets" {
  type    = list(string)
  default = []
}

variable "private_subnet_tags" {
  type    = map(any)
  default = {}
}

variable "transit_gateway_subnets" {
  type = list(string)
}

variable "transit_gateway_subnet_tags" {
  type    = map(any)
  default = {}
}

variable "internet_gateway" {
  type    = bool
  default = false
}

variable "nat_gateways" {
  type    = bool
  default = false
}
