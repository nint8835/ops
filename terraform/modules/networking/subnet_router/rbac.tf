resource "kubernetes_role_v1" "role" {
  metadata {
    name      = var.router_name
    namespace = var.namespace
  }

  rule {
    api_groups     = [""]
    resource_names = [kubernetes_secret_v1.state.metadata[0].name]
    resources      = ["secrets"]
    verbs          = ["get", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["get", "create", "patch"]
  }
}

resource "kubernetes_service_account_v1" "service_account" {
  metadata {
    name      = var.router_name
    namespace = var.namespace
  }
}

resource "kubernetes_role_binding_v1" "binding" {
  metadata {
    name      = var.router_name
    namespace = var.namespace
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.service_account.metadata[0].name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.role.metadata[0].name
  }
}
