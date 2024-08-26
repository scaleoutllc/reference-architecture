module "external-dns" {
  source            = "../../../../../../../terraform-modules/cluster/services/gcp-external-dns"
  cluster_name      = data.google_container_cluster.this.name
  cluster_self_link = data.google_container_cluster.this.self_link
}
