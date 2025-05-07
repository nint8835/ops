resource "kubernetes_deployment" "router" {
  metadata {
    name      = var.router_name
    namespace = var.namespace
  }

  spec {
    selector {
      match_labels = {
        app   = "tailscale"
        route = var.router_name
      }
    }

    replicas = 1

    template {
      metadata {
        labels = {
          app          = "tailscale"
          route        = var.router_name
          router-group = var.router_group
        }
      }

      spec {
        service_account_name = kubernetes_service_account.service_account.metadata[0].name

        container {
          name              = "tailscale"
          image_pull_policy = "IfNotPresent"
          image             = "ghcr.io/tailscale/tailscale:v1.82.5"

          env {
            name  = "TS_KUBE_SECRET"
            value = kubernetes_secret.state.metadata[0].name
          }

          env {
            name  = "TS_USERSPACE"
            value = "false"
          }

          env {
            name  = "TS_DEBUG_FIREWALL_MODE"
            value = "auto"
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
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "POD_UID"
            value_from {
              field_ref {
                field_path = "metadata.uid"
              }
            }
          }

          resources {
            requests = {
              memory = "64Mi"
            }
            limits = {
              memory = "128Mi"
            }
          }

          security_context {
            privileged = true
          }
        }

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100
              pod_affinity_term {
                topology_key = "topology.kubernetes.io/zone"
                label_selector {
                  match_labels = {
                    router-group = var.router_group
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
