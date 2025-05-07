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
  version    = "35.2.0"

  set {
    name  = "logs.access.enabled"
    value = true
  }

  set {
    name  = "logs.access.format"
    value = "json"
  }

  set {
    name  = "logs.general.format"
    value = "json"
  }

  set {
    name  = "providers.kubernetesCRD.allowCrossNamespace"
    value = true
  }

  set {
    name  = "deployment.kind"
    value = "DaemonSet"
  }

  set {
    name  = "resources.requests.memory"
    value = "64Mi"
  }

  set {
    name  = "resources.limits.memory"
    value = "64Mi"
  }

  # TODO: See if there's a way to not need insecure
  # My Rube Goldberg-esque networking solution leaves me with unpredictable source IPs
  set {
    name  = "ports.web.proxyProtocol.insecure"
    value = true
  }
  set {
    name  = "ports.websecure.proxyProtocol.insecure"
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

resource "kubernetes_secret" "traefik_dashboard_auth" {
  metadata {
    name      = "traefik-dashboard-auth"
    namespace = kubernetes_namespace.traefik.id
  }

  data = {
    users = var.traefik_basic_auth_entry
  }
}

resource "kubernetes_manifest" "traefik_dashboard_auth" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "Middleware"

    metadata = {
      name      = "traefik-dashboard-auth"
      namespace = kubernetes_namespace.traefik.id
    }

    spec = {
      basicAuth = {
        secret = kubernetes_secret.traefik_dashboard_auth.metadata[0].name
      }
    }
  }
}

resource "cloudflare_dns_record" "traefik_dashboard" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "traefik.ops.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "kubernetes_manifest" "traefik_dashboard" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "IngressRoute"

    metadata = {
      name      = "traefik-dashboard"
      namespace = kubernetes_namespace.traefik.id
    }

    spec = {
      routes = [
        {
          kind  = "Rule"
          match = "Host(`traefik.ops.bootleg.technology`)"

          middlewares = [
            {
              name      = kubernetes_manifest.traefik_dashboard_auth.manifest.metadata.name
              namespace = kubernetes_manifest.traefik_dashboard_auth.manifest.metadata.namespace
            },
          ]

          services = [
            {
              kind = "TraefikService"
              name = "api@internal"
            },
          ]
        },
      ]
    }
  }
}
