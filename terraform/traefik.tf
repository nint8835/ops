resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "helm_release" "traefik" {
  repository = "https://traefik.github.io/charts"

  name      = "traefik"
  chart     = "traefik"
  namespace = kubernetes_namespace.traefik.id

  # TODO: Make this accessible again
  set {
    name  = "ingressRoute.dashboard.entryPoints[0]"
    value = "traefik"
  }
}