resource "kubernetes_secret_v1" "state" {
  metadata {
    name      = "${var.router_name}-state"
    namespace = var.namespace
  }

  data = {}

  lifecycle {
    ignore_changes = [data]
  }
}
