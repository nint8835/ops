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

variable "device_type_id" {
  description = "ID of the Netbox device type to use for this host"
  type        = number
}

variable "site_id" {
  description = "ID of the Netbox site for this host"
  type        = number
}

variable "location_id" {
  description = "ID of the Netbox location for this host"
  type        = number
}

variable "rack_id" {
  description = "ID of the Netbox rack for this host"
  type        = number
}

variable "role_id" {
  description = "ID of the Netbox device role to use for this host"
  type        = number
}

variable "cluster_id" {
  description = "ID of the Netbox cluster to assign this host to"
  type        = number
}

variable "rack_position" {
  description = "Position of this host within the rack. Leave as default if the host is not racked or is mounted on a shelf"
  type        = number
  default     = 0
}
