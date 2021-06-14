variable "vault_access_token" {
  type        = string
  description = "Vault access token to be used to authenticate provider."
}

variable "vault_address" {
  type        = string
  default     = "http://vault.internal.bootleg.technology"
  description = "Vault server address."
}

variable "digitalocean_token" {
  type        = string
  description = "Token to use to authenticate with DigitalOcean."
}
