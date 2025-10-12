variable "tag" {
  description = "Tag for this VLAN."
  type        = number
}

variable "name" {
  description = "Name for this VLAN."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for this VLAN."
  type        = string
}

variable "mark_utilized" {
  description = "Mark this VLAN's prefix as utilized."
  type        = bool
  default     = false
}
