resource "kubernetes_pod" "router" {
  metadata {
    name      = var.router_name
    namespace = var.namespace
    labels = {
      app = "tailscale"
    }
  }

  spec {
    service_account_name = kubernetes_service_account.service_account.metadata[0].name

    container {
      name              = "tailscale"
      image_pull_policy = "Always"
      image             = "ghcr.io/tailscale/tailscale:latest"

      env {
        name  = "TS_KUBE_SECRET"
        value = kubernetes_secret.state.metadata[0].name
      }

      env {
        name  = "TS_USERSPACE"
        value = "true"
      }

      env {
        name = "TS_AUTHKEY"
        value_from {
          secret_key_ref {
            name     = var.ts_auth_key_secret
            key      = "TS_AUTHKEY"
            optional = true
          }
        }
      }

      env {
        name  = "TS_ROUTES"
        value = join(",", var.routes)
      }

      env {
        name  = "TS_HOSTNAME"
        value = var.router_name
      }
    }

    security_context {
      run_as_user  = 1000
      run_as_group = 1000
    }
  }
}