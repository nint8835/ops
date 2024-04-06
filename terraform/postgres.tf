resource "kubernetes_namespace" "cnpg_system" {
  metadata {
    name = "cnpg-system"
  }
}

resource "helm_release" "cloudnativepg" {
  repository = "https://cloudnative-pg.github.io/charts"
  name       = "cnpg"
  chart      = "cloudnative-pg"
  namespace  = kubernetes_namespace.cnpg_system.metadata.0.name
  version    = "0.20.2"
}
