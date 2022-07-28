provider "proxmox" {
  pm_api_url      = var.proxmox_url
  pm_tls_insecure = true
  #  pm_user             = var.proxmox_username
  pm_api_token_id     = var.proxmox_username
  pm_api_token_secret = var.proxmox_token
}
