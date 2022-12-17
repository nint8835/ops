provider "netbox" {
  server_url         = var.netbox_url
  api_token          = var.netbox_token
  skip_version_check = true
}
