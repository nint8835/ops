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

  set {
    name  = "image.repository"
    value = "registry.internal.bootleg.technology/ghcr/cloudnative-pg/cloudnative-pg"
  }
}

resource "kubernetes_manifest" "cloudnativepg_imagecatalog" {
  manifest = {
    apiVersion = "postgresql.cnpg.io/v1"
    kind       = "ClusterImageCatalog"

    metadata = {
      name = "postgresql"
    }

    spec = {
      images = [
        {
          major = 16
          image = "registry.internal.bootleg.technology/ghcr/cloudnative-pg/postgresql:16.1"
        }
      ]
    }
  }
}
