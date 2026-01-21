variable "digitalocean_token" {
  type        = string
  description = "Token to use to authenticate with DigitalOcean."
  sensitive   = true
}

variable "cluster_name" {
  description = "Name for the Talos cluster"
  type        = string
  default     = "hera"
}

variable "lb_ip_range" {
  description = "Range of IPs to use for the MetalLB load balancer"
  type        = string
  default     = "10.8.240.0/20"
}

variable "tailscale_api_key" {
  description = "Tailscale API key"
  type        = string
  sensitive   = true
}

variable "tailscale_tailnet_name" {
  description = "Name of the Tailscale tailnet to use"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "github_app_id" {
  description = "GitHub App ID"
  type        = string
}

variable "github_app_installation_id" {
  description = "GitHub App Installation ID"
  type        = string
}

variable "age_secret_key" {
  description = "Secret key to use for Age encryption"
  type        = string
  sensitive   = true
}

variable "traefik_basic_auth_entry" {
  description = "Output of htpasswd for the credentials to use for the Traefik dashboard"
  type        = string
  sensitive   = true
}

variable "cert_manager_cloudflare_api_token" {
  description = "Cloudflare API token for cert-manager"
  type        = string
  sensitive   = true
}

variable "proxmox_username" {
  description = "Proxmox username"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "netbox_token" {
  description = "Netbox API token"
  type        = string
  sensitive   = true
}

variable "coder_token" {
  description = "Coder API token"
  type        = string
  sensitive   = true
}
