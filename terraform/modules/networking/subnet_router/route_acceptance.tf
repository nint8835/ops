data "tailscale_devices" "router" {
  depends_on = [kubernetes_pod.router]

  name_prefix = var.router_name
}

resource "tailscale_device_subnet_routes" "service_router" {
  for_each = toset([for device in data.tailscale_devices.router.devices : device.id])

  device_id = each.key
  routes    = var.routes
}
