provider "vault" {
  address = var.vault_address
  token   = var.vault_access_token
}

provider "digitalocean" {
  token = var.digitalocean_token
}
