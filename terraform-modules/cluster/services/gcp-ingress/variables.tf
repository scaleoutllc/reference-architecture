variable "name" {
  type = string
}

variable "project" {
  type = string
}

variable "global_load_balancer_name" {
  type = string
}

variable "load_balancer_domains" {
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

variable "gateway_version" {
  type = string
}

variable "cert_map_name" {
  type = string
}
