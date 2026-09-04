variable "name" {
  description = "Name of this host"
  type        = string
}

variable "ip" {
  description = "IP address of this host"
  type        = string
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
