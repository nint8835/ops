data "tailscale_device" "router" {
  depends_on = [kubernetes_pod.router]

  name     = "${var.router_name}.${var.ts_subdomain}"
  wait_for = "60s"
}

resource "tailscale_device_subnet_routes" "service_router" {
  device_id = data.tailscale_device.router.id
  routes    = var.routes
}