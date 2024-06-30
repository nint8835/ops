resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  namespace = kubernetes_namespace.cert_manager.id

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.15.1"

  set {
    name  = "installCRDs"
    value = true
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
