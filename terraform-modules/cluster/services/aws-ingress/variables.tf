variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "domain" {
  type = string
}

variable "sans" {
  type = list(string)
}

variable "zone_id" {
  type = string
}

variable "replicas" {
  type = number
}

variable "node_selector" {
  type = string
}

variable "istio_rev" {
  type = string
}

variable "load_balancer_domains" {
  type = list(string)
}

variable "gateway_version" {
  type = string
}
