output "private_key" {
  sensitive = true
  value     = tls_private_key.ca.private_key_pem
}

output "cert" {
  sensitive = true
  value     = tls_self_signed_cert.ca.cert_pem
}
