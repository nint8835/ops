resource "kubernetes_namespace" "harbor" {
  metadata {
    name = "harbor"
  }
}

resource "random_password" "harbor_password" {
  length  = 16
  special = true
}

resource "random_password" "harbor_secret_key" {
  length  = 16
  special = true
}

resource "random_password" "harbor_postgres_password" {
  length  = 16
  special = true
}

resource "helm_release" "harbor" {
  name      = "harbor"
  namespace = kubernetes_namespace.harbor.id

  repository = "https://helm.goharbor.io"
  chart      = "harbor"
  version    = "1.16.2"

  set {
    name  = "externalURL"
    value = "https://registry.internal.bootleg.technology"
  }

  set {
    name  = "expose.ingress.hosts.core"
    value = "registry.internal.bootleg.technology"
  }

  set {
    name  = "expose.ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt"
  }

  set {
    name  = "expose.ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.middlewares"
    value = "traefik-https-redirect@kubernetescrd"
  }

  dynamic "set" {
    for_each = toset(["registry", "jobservice.jobLog", "database", "redis"])

    content {
      name  = "persistence.persistentVolumeClaim.${set.value}.storageClass"
      value = "nfs-csi"
    }
  }

  dynamic "set" {
    for_each = toset(["registry", "jobservice.jobLog", "database", "redis"])

    content {
      name  = "persistence.persistentVolumeClaim.${set.value}.accessMode"
      value = "ReadWriteMany"
    }
  }

  set_sensitive {
    name  = "harborAdminPassword"
    value = random_password.harbor_password.result
  }

  set_sensitive {
    name  = "secretKey"
    value = random_password.harbor_secret_key.result
  }

  set {
    name  = "trivy.enabled"
    value = false
  }

  set_sensitive {
    name  = "database.internal.password"
    value = random_password.harbor_postgres_password.result
  }
}

resource "cloudflare_dns_record" "registry" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "registry.internal.bootleg.technology"
  content = "10.8.240.0"
  type    = "A"
  ttl     = 1
}
