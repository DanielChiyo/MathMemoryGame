data "google_client_config" "default" {}

output host {
  value       = "https://${google_container_cluster.default.endpoint}"
}

output token {
  value       = data.google_client_config.default.access_token
}

output cluster_ca_certificate {
  value       = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)
}
