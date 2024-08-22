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

variable "node_label_root" {
  type = string
}

variable "load_balancer_domains" {
  type = list(string)
}
