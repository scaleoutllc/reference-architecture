variable "name" {
  type        = string
  description = "A name for the VM."
}

variable "location" {
  type        = string
  description = "A name for the VM."
}

variable "username" {
  type        = string
  description = "Username for logging into the VM."
}

variable "public_key" {
  type        = string
  description = "Path to public key for logging into the VM."
}

variable "subnet_id" {
  type        = string
  description = "Subnet to run VM in."
}