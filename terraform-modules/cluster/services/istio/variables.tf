variable "name" {
  type = string
}

variable "deployments" {
  type = object({
    blue  = object({ deployed = bool, version = string })
    green = object({ deployed = bool, version = string })
  })
}

variable "replicas" {
  type = number
}

variable "mesh_id" {
  type = string
}

variable "network" {
  type = string
}

variable "node_selector" {
  type = string
}
