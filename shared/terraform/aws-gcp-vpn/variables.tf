variable "name" {
  type = string
}
variable "region" {
  type = string
}

variable "asn" {
  type = object({
    gcp = string
    aws = string
  })
}

variable "gcp_network_name" {
  type = string
}

variable "aws_transit_gateway_id" {
  type = string
}

variable "gcp_cloud_router_name" {
  type = string
}
