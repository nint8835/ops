resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_secret_v1" "certmanager_cloudflare_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = kubernetes_namespace_v1.cert_manager.id
  }

  data = {
    api-token = var.cert_manager_cloudflare_api_token
  }
}

resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  namespace = kubernetes_namespace_v1.cert_manager.id

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.21.2"

  max_history = 3

  values = [
    yamlencode({
      crds = {
        enabled = true
        keep    = true
      }
      resources = {
        requests = { memory = "32Mi" }
        limits   = { memory = "96Mi" }
      }
      cainjector = {
        resources = {
          requests = { memory = "64Mi" }
          limits   = { memory = "128Mi" }
        }
      }
      webhook = {
        resources = {
          requests = { memory = "16Mi" }
          limits   = { memory = "64Mi" }
        }
      }
    })
  ]
}

module "cert_manager_configs_hash" {
  source    = "./modules/utils/hash_directory"
  directory = "${path.module}/charts/cert-manager-configs"
}

resource "helm_release" "cert_manager_configs" {
  name      = "cert-manager-configs"
  namespace = kubernetes_namespace_v1.cert_manager.id
  chart     = "${path.module}/charts/cert-manager-configs"

  max_history = 3

  set = [
    {
      name  = "_hash"
      value = module.cert_manager_configs_hash.hash
    },
    {
      name  = "cloudflareSecretName"
      value = kubernetes_secret_v1.certmanager_cloudflare_token.metadata[0].name
    },
  ]

  depends_on = [
    helm_release.cert_manager,
  ]
}
