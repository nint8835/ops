variable "netbox_url" {
  description = "URL to the NetBox instance to use"
  type        = string
  default     = "http://localhost:8000"
}

variable "netbox_token" {
  description = "API token for NetBox"
  type        = string
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
}

variable "tailscale_tailnet_name" {
  description = "Name of the Tailscale tailnet to use"
  type        = string
}

variable "tailscale_ts_domain" {
  description = ".ts.net domain corresponding with the tailnet to use"
  type        = string
}
