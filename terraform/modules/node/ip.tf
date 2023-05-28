resource "netbox_ip_address" "ip" {
  ip_address  = "${var.ip}/32"
  description = var.name
  status      = "active"

  # Added due to the provider continually trying to update this field
  lifecycle {
    ignore_changes = [object_type]
  }
}