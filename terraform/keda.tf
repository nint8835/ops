resource "kubernetes_namespace_v1" "keda" {
  metadata {
    name = "keda"
  }
}

resource "helm_release" "keda" {
  name      = "keda"
  namespace = kubernetes_namespace_v1.keda.id

  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = "2.20.2"

  max_history = 3
}

resource "helm_release" "keda_http_addon" {
  name      = "keda-http-add-on"
  namespace = kubernetes_namespace_v1.keda.id

  repository = "https://kedacore.github.io/charts"
  chart      = "keda-add-ons-http"
  version    = "0.15.0"

  max_history = 3
}
