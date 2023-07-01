variable "name" {
  description = "The droplet name."
  type        = string
}

variable "memory" {
  description = "The amount of memory required for this droplet, measured in MB."
  type        = number
}

variable "vcpus" {
  description = "The number of vCPUs required for this droplet."
  type        = number
}

variable "ssh_key_ids" {
  description = "IDs of SSH keys that will be permitted to connect. Leave blank to add all keys in the account."
  type        = list(string)
  default     = []
}

variable "region" {
  description = "The region to launch this droplet in."
  default     = "tor1"
  type        = string
}

variable "distribution" {
  description = "Distribution to use for the droplet."
  type        = string
  default     = "Debian"
}

variable "distribution_version" {
  description = "Version of the Distribution to use for the droplet."
  type        = string
  default     = "12 x64"
}

variable "ingress_rules" {
  description = "Inbound traffic from the public internet that should be permitted. Leave blank to permit all traffic."
  type = list(
    object(
      {
        protocol         = string,
        port_range       = string,
        source_addresses = list(string)
      }
    )
  )
  default = []
}

variable "userdata" {
  description = "Cloud-init userdata for the node. Leave blank to use no userdata."
  type        = string
  default     = ""
}

variable "use_static_ip" {
  description = "Whether to use a static IP address for the droplet."
  type        = bool
  default     = false
}
