resource "kubernetes_secret" "state" {
  metadata {
    name      = "${var.router_name}-state"
    namespace = var.namespace
  }

  data = {}

  lifecycle {
    ignore_changes = [data]
  }
}
