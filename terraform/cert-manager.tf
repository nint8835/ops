resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_secret" "certmanager_cloudflare_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = kubernetes_namespace.cert_manager.id
  }

  data = {
    api-token = var.cert_manager_cloudflare_api_token
  }
}

resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  namespace = kubernetes_namespace.cert_manager.id

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.19.1"

  set = [
    {
      name  = "installCRDs"
      value = true
    },
    {
      name  = "resources.requests.memory"
      value = "32Mi"
    },
    {
      name  = "resources.limits.memory"
      value = "64Mi"
    },
    {
      name  = "cainjector.resources.requests.memory"
      value = "64Mi"
    },
    {
      name  = "cainjector.resources.limits.memory"
      value = "128Mi"
    },
    {
      name  = "webhook.resources.requests.memory"
      value = "16Mi"
    },
    {
      name  = "webhook.resources.limits.memory"
      value = "64Mi"
    },
  ]
}

module "cert_manager_configs_hash" {
  source    = "./modules/utils/hash_directory"
  directory = "${path.module}/charts/cert-manager-configs"
}

resource "helm_release" "cert_manager_configs" {
  name      = "cert-manager-configs"
  namespace = kubernetes_namespace.cert_manager.id
  chart     = "${path.module}/charts/cert-manager-configs"

  set = [
    {
      name  = "_hash"
      value = module.cert_manager_configs_hash.hash
    },
    {
      name  = "cloudflareSecretName"
      value = kubernetes_secret.certmanager_cloudflare_token.metadata[0].name
    },
  ]

  depends_on = [
    helm_release.cert_manager,
  ]
}
