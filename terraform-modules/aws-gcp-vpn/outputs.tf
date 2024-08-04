output "tunnel_self_links" {
  value = [for v in google_compute_vpn_tunnel.main : v.id]
}
