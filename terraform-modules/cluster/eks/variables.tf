variable "name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "core_dns_version" {
  type = string
}

variable "node_label_root" {
  type = string
}

#variable "vpc_interface_security_group_id" {
#  type = string
#}
