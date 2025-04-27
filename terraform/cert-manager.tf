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
  version    = "v1.17.2"

  set {
    name  = "installCRDs"
    value = true
  }

  set {
    name  = "resources.requests.memory"
    value = "32Mi"
  }

  set {
    name  = "resources.limits.memory"
    value = "64Mi"
  }

  set {
    name  = "cainjector.resources.requests.memory"
    value = "64Mi"
  }

  set {
    name  = "cainjector.resources.limits.memory"
    value = "128Mi"
  }

  set {
    name  = "webhook.resources.requests.memory"
    value = "16Mi"
  }

  set {
    name  = "webhook.resources.limits.memory"
    value = "64Mi"
  }
}

resource "kubernetes_manifest" "letsencrypt_staging_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-staging"
    }

    spec = {
      acme = {
        email  = "riley@rileyflynn.me"
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = {
          name = "letsencrypt-staging-account-key"
        }
        solvers = [
          {
            dns01 = {
              cloudflare = {
                apiTokenSecretRef = {
                  name = kubernetes_secret.certmanager_cloudflare_token.metadata[0].name
                  key  = "api-token"
                }
              }
            }
            selector = {
              dnsZones = [
                "internal.bootleg.technology",
              ]
            }
          },
          {
            http01 = {
              ingress = {
                ingressClassName = "traefik"
              }
            }
          }
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "letsencrypt_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt"
    }

    spec = {
      acme = {
        email  = "riley@rileyflynn.me"
        server = "https://acme-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = {
          name = "letsencrypt-account-key"
        }
        solvers = [
          {
            dns01 = {
              cloudflare = {
                apiTokenSecretRef = {
                  name = kubernetes_secret.certmanager_cloudflare_token.metadata[0].name
                  key  = "api-token"
                }
              }
            }
            selector = {
              dnsZones = [
                "internal.bootleg.technology",
              ]
            }
          },
          {
            http01 = {
              ingress = {
                ingressClassName = "traefik"
              }
            }
          }
        ]
      }
    }
  }
}
