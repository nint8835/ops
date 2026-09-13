resource "kubernetes_namespace_v1" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "helm_release" "traefik" {
  name      = "traefik"
  namespace = kubernetes_namespace_v1.traefik.id

  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  version    = "41.5.0"

  max_history = 3

  values = [
    yamlencode({
      accessLog = {
        enabled = true
        format  = "json"
      }
      log = { format = "json" }
      providers = {
        kubernetesCRD = { allowCrossNamespace = true }
      }
      deployment = { kind = "DaemonSet" }
      resources = {
        requests = { memory = "64Mi" }
        limits   = { memory = "256Mi" }
      }
      service = {
        spec = { externalTrafficPolicy = "Local" }
      }
      additionalArguments = [
        "--entrypoints.web.transport.respondingTimeouts.readTimeout=300s",
        "--entrypoints.websecure.transport.respondingTimeouts.readTimeout=300s",
      ]
    })
  ]
}

resource "kubernetes_secret_v1" "traefik_dashboard_auth" {
  metadata {
    name      = "traefik-dashboard-auth"
    namespace = kubernetes_namespace_v1.traefik.id
  }

  data = {
    users = var.traefik_basic_auth_entry
  }
}

module "traefik_configs_hash" {
  source    = "./modules/utils/hash_directory"
  directory = "${path.module}/charts/traefik-configs"
}

resource "helm_release" "traefik_configs" {
  name      = "traefik-configs"
  namespace = kubernetes_namespace_v1.traefik.id
  chart     = "${path.module}/charts/traefik-configs"

  max_history = 3

  set = [
    {
      name  = "_hash"
      value = module.traefik_configs_hash.hash
    },
    {
      name  = "traefikDashboardAuthSecret"
      value = kubernetes_secret_v1.traefik_dashboard_auth.metadata[0].name
    },
  ]

  depends_on = [
    helm_release.traefik,
  ]
}
