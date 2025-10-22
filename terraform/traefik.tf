resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "helm_release" "traefik" {
  name      = "traefik"
  namespace = kubernetes_namespace.traefik.id

  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  version    = "37.2.0"

  set = [
    {
      name  = "logs.access.enabled"
      value = true
    },
    {
      name  = "logs.access.format"
      value = "json"
    },
    {
      name  = "logs.general.format"
      value = "json"
    },
    {
      name  = "providers.kubernetesCRD.allowCrossNamespace"
      value = true
    },
    {
      name  = "deployment.kind"
      value = "DaemonSet"
    },
    {
      name  = "resources.requests.memory"
      value = "64Mi"
    },
    {
      name  = "resources.limits.memory"
      value = "64Mi"
    },
    # TODO: See if there's a way to not need insecure
    # My Rube Goldberg-esque networking solution leaves me with unpredictable source IPs
    {
      name  = "ports.web.proxyProtocol.insecure"
      value = true
    },
    {
      name  = "ports.websecure.proxyProtocol.insecure"
      value = true
    },
  ]
}

resource "kubernetes_secret" "traefik_dashboard_auth" {
  metadata {
    name      = "traefik-dashboard-auth"
    namespace = kubernetes_namespace.traefik.id
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
  namespace = kubernetes_namespace.traefik.id
  chart     = "${path.module}/charts/traefik-configs"

  set = [
    {
      name  = "_hash"
      value = module.traefik_configs_hash.hash
    },
    {
      name  = "traefikDashboardAuthSecret"
      value = kubernetes_secret.traefik_dashboard_auth.metadata[0].name
    },
  ]

  depends_on = [
    helm_release.traefik,
  ]
}
