resource "netbox_ip_address" "gateway" {
  description = "${var.name} gateway"
  status      = "reserved"
  ip_address  = "${cidrhost(var.cidr_block, 1)}/32"

  # Added due to the provider continually trying to update this field
  lifecycle {
    ignore_changes = [object_type]
  }
}

resource "netbox_ip_address" "broadcast" {
  description = "${var.name} broadcast"
  status      = "reserved"
  ip_address  = "${cidrhost(var.cidr_block, -1)}/32"

  # Added due to the provider continually trying to update this field
  lifecycle {
    ignore_changes = [object_type]
  }
}