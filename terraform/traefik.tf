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

  set {
    name  = "logs.access.enabled"
    value = true
  }

  set {
    name  = "providers.kubernetesCRD.allowCrossNamespace"
    value = true
  }
}

resource "kubernetes_manifest" "traefik_https_redirect" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "Middleware"

    metadata = {
      name      = "https-redirect"
      namespace = kubernetes_namespace.traefik.id
    }

    spec = {
      redirectScheme = {
        scheme    = "https"
        permanent = true
      }
    }
  }
}
