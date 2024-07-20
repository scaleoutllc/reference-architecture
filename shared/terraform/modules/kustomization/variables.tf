variable "path" {
  type = string
}

variable "cluster" {
  type = object({
    host                   = string
    cluster_ca_certificate = string
    token                  = string
  })
}
