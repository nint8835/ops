resource "kubernetes_namespace" "longhorn-system" {
  metadata {
    name = "longhorn-system"
  }
}

resource "helm_release" "longhorn" {
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  name       = "longhorn"
  version    = "1.2.3"

  namespace = kubernetes_namespace.longhorn-system.id
}
