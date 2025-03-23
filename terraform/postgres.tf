resource "kubernetes_namespace" "cnpg_system" {
  metadata {
    name = "cnpg-system"
  }
}

resource "helm_release" "cloudnativepg" {
  name      = "cnpg"
  namespace = kubernetes_namespace.cnpg_system.metadata[0].name

  repository = "https://cloudnative-pg.github.io/charts"
  chart      = "cloudnative-pg"
  version    = "0.23.2"

  set {
    name  = "resources.requests.memory"
    value = "64Mi"
  }

  set {
    name  = "resources.limits.memory"
    value = "192Mi"
  }
}
