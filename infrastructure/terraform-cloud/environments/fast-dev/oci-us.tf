# terraform {
#   required_providers {
#     oci = {
#       source  = "hashicorp/oci"
#       version = "5.38.0"
#     }
#   }
#   cloud {
#     organization = "scaleout"
#     workspaces {
#       project = "terraform-cloud"
#       name    = "terraform-cloud-fast-dev-oci"
#     }
#   }
# }

# variable "region" {}
# variable "tenancy_ocid" {}
# variable "user_ocid" {}
# variable "fingerprint" {}
# variable "private_key" {}
# variable "compartment_id" {}

# provider "oci" {
#   region       = var.region
#   tenancy_ocid = var.tenancy_ocid
#   user_ocid    = var.user_ocid
#   fingerprint  = var.fingerprint
#   private_key  = var.private_key
# }

# // Created manually when setting up TFC.
# data "tfe_oauth_client" "github" {
#   organization     = "scaleout"
#   service_provider = "github"
# }


# locals {
#   fast-dev-oci-us = {
#     tenancy_id     = "ocid1.tenancy.oc1..aaaaaaaaqmdyo455h7pgzmgvsn5ue4dg73oxhp47udjc66c3vlg5h7wyzvsa"
#     compartment_id = "ocid1.tenancy.oc1..aaaaaaaaqmdyo455h7pgzmgvsn5ue4dg73oxhp47udjc66c3vlg5h7wyzvsa"
#     admin_group_id = "ocid1.group.oc1..aaaaaaaaoovxzrfd2dnffczohw4hedwdcw5tikv2tbq55ow2xlnmysvh3nza"
#     region         = "us-chicago-1"
#   }
# }

# resource "tls_private_key" "fast-dev-oci-us" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "oci_identity_user" "fast-dev-oci-us" {
#   compartment_id = local.fast-dev-oci-us.compartment_id
#   description    = "Terraform Cloud"
#   name           = "tfc-fast-dev-oci-us"
#   email          = "info@wescaleout.com"
# }

# resource "oci_identity_api_key" "fast-dev-oci-us" {
#   key_value = tls_private_key.fast-dev-oci-us.public_key_pem
#   user_id   = oci_identity_user.fast-dev-oci-us.id
# }

# resource "oci_identity_user_group_membership" "us-admin" {
#   group_id = local.fast-dev-oci-us.admin_group_id
#   user_id  = oci_identity_user.fast-dev-oci-us.id
# }

# resource "tfe_project" "fast-dev-oci-us" {
#   organization = "scaleout"
#   name         = "fast-dev-oci-us"
# }

# resource "tfe_variable_set" "fast-dev-oci-us" {
#   name         = "fast-dev-oci-us"
#   organization = "scaleout"
# }

# resource "tfe_variable" "fast-dev-oci-us" {
#   for_each = {
#     tenancy_ocid     = { value = local.fast-dev-oci-us.tenancy_id, sensitive = false },
#     compartment_ocid = { value = local.fast-dev-oci-us.compartment_id, sensitive = false },
#     user_ocid        = { value = oci_identity_user.fast-dev-oci-us.id, sensitive = false },
#     fingerprint      = { value = oci_identity_api_key.fast-dev-oci-us.fingerprint, sensitive = false },
#     region           = { value = local.fast-dev-oci-us.region, sensitive = false },
#     private_key      = { value = tls_private_key.fast-dev-oci-us.private_key_pem, sensitive = true },
#   }
#   variable_set_id = tfe_variable_set.fast-dev-oci-us.id
#   key             = each.key
#   value           = each.value.value
#   sensitive       = each.value.sensitive
#   category        = "terraform"
# }

# resource "tfe_project_variable_set" "fast-dev-oci-us" {
#   project_id      = tfe_project.fast-dev-oci-us.id
#   variable_set_id = tfe_variable_set.fast-dev-oci-us.id
# }

# resource "tfe_workspace" "fast-dev-oci-us" {
#   for_each = toset([
#     "network",
#     "cluster/oke",
#     "cluster/nodes",
#     "cluster/registry",
#     "cluster/namespaces/istio-system",
#     "cluster/namespaces/kube-system",
#     "cluster/namespaces/main",
#   ])
#   name                = "${tfe_project.fast-dev-oci-us.name}-${replace(each.value, "/", "-")}"
#   organization        = "scaleout"
#   project_id          = tfe_project.fast-dev-oci-us.id
#   working_directory   = "infrastructure/environments/fast-dev/oci/us/${each.value}"
#   global_remote_state = true
#   vcs_repo {
#     identifier     = "scaleoutllc/reference-architecture"
#     oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
#     branch         = "main"
#   }
#   lifecycle {
#     prevent_destroy = false
#   }
# }

# // Allow running locally for speed of initial creation/debugging.
# resource "tfe_workspace_settings" "fast-dev-oci-us" {
#   for_each       = tfe_workspace.fast-dev-oci-us
#   workspace_id   = each.value.id
#   execution_mode = "local"
# }
