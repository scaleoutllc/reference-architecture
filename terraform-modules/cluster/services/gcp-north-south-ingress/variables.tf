variable "name" {
  type = string
}

variable "team" {
  type = string
}

variable "env" {
  type = string
}

variable "area" {
  type = string
}

variable "project" {
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
