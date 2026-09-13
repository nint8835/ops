variable "name" {
  description = "Name of this host"
  type        = string
}

variable "ip" {
  description = "IP address of this host"
  type        = string

  validation {
    condition     = can(cidrnetmask("${var.ip}/32"))
    error_message = "IP must be a valid IPv4 address without a prefix length."
  }
}

variable "subdomain" {
  description = "Subdomain of zone_domain to use for this host's DNS record"
  type        = string
  default     = "hosts.bootleg.technology"
}

variable "zone_id" {
  description = "Zone ID to use for this host's DNS record"
  type        = string
}
