variable "values" {
  type    = string
  default = ""
}

variable "aws_privateca_arn" {
  type = string
}

variable "aws_privateca_region" {
  type = string
}

variable "aws_privateca_access_key_id" {
  type    = string
  default = ""
}

variable "aws_privateca_secret_access_key" {
  type    = string
  default = ""
}

variable "letsencrypt_email" {
  type    = string
  default = ""
}

variable "letsencrypt_private_key" {
  type    = string
  default = ""
}

variable "letsencrypt_route53_aws_region" {
  type    = string
  default = ""
}

variable "letsencrypt_route53_aws_access_key_id" {
  type    = string
  default = ""
}

variable "letsencrypt_route53_aws_secret_access_key" {
  type    = string
  default = ""
}
