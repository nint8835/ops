resource "kubernetes_namespace" "tailscale" {
  metadata {
    name = "tailscale"
  }
}

resource "tailscale_tailnet_key" "k8s" {
  reusable      = true
  ephemeral     = true
  preauthorized = true
  expiry        = 90 * 24 * 60 * 60
  tags          = ["tag:k8s"]
}

resource "tailscale_tailnet_key" "droplet" {
  reusable      = true
  ephemeral     = true
  preauthorized = true
  expiry        = 90 * 24 * 60 * 60
  tags          = ["tag:droplet"]
}

resource "kubernetes_secret" "tailscale_auth" {
  metadata {
    name      = "tailscale-auth"
    namespace = kubernetes_namespace.tailscale.metadata[0].name
  }

  data = {
    TS_AUTHKEY = tailscale_tailnet_key.k8s.key
  }
}

module "service_router" {
  source = "./modules/networking/subnet_router"

  router_name        = "k8s-service-router"
  namespace          = kubernetes_namespace.tailscale.id
  ts_auth_key_secret = kubernetes_secret.tailscale_auth.metadata[0].name
  ts_subdomain       = var.tailscale_ts_domain
  routes             = [var.lb_ip_range]
}
