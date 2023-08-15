data "tailscale_devices" "router" {
  depends_on = [kubernetes_deployment.router]

  name_prefix = var.router_name
}

resource "tailscale_device_subnet_routes" "service_router" {
  device_id = data.tailscale_devices.router.devices[0].id
  routes    = var.routes
}
