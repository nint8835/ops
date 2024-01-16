resource "kubernetes_namespace" "lgtm" {
  metadata {
    name = "lgtm"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

resource "cloudflare_record" "grafana" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "grafana.ops"
  value   = module.bastion_host.public_ip
  type    = "A"
}

resource "helm_release" "grafana" {
  repository = "https://grafana.github.io/helm-charts"

  name      = "grafana"
  chart     = "grafana"
  namespace = kubernetes_namespace.lgtm.id

  set {
    name  = "persistence.enabled"
    value = true
  }

  set {
    name  = "persistence.storageClassName"
    value = "nfs-csi"
  }

  set {
    name  = "ingress.enabled"
    value = true
  }

  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt"
  }

  set {
    name  = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.middlewares"
    value = "traefik-https-redirect@kubernetescrd"
  }

  set {
    name  = "ingress.hosts[0]"
    value = "grafana.ops.bootleg.technology"
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "grafana.ops.bootleg.technology"
  }

  set {
    name  = "ingress.tls[0].secretName"
    value = "grafana-tls"
  }

  set {
    name  = "grafana\\.ini.server.root_url"
    value = "https://grafana.ops.bootleg.technology"
  }
}


resource "helm_release" "loki" {
  repository = "https://grafana.github.io/helm-charts"

  name      = "loki"
  chart     = "loki"
  namespace = kubernetes_namespace.lgtm.id

  set {
    name  = "singleBinary.replicas"
    value = 1
  }

  set {
    name  = "singleBinary.persistence.storageClass"
    value = "nfs-csi"
  }

  set {
    name  = "loki.commonConfig.replication_factor"
    value = 1
  }

  set {
    name  = "loki.storage.type"
    value = "filesystem"
  }

  set {
    name  = "loki.auth_enabled"
    value = false
  }

  set {
    name  = "monitoring.lokiCanary.enabled"
    value = false
  }

  set {
    name  = "test.enabled"
    value = false
  }

  set {
    name  = "monitoring.selfMonitoring.enabled"
    value = false
  }

  set {
    name  = "monitoring.selfMonitoring.grafanaAgent.installOperator"
    value = false
  }
}

resource "helm_release" "promtail" {
  repository = "https://grafana.github.io/helm-charts"

  name      = "promtail"
  chart     = "promtail"
  namespace = kubernetes_namespace.lgtm.id
}

resource "helm_release" "prometheus" {
  repository = "https://prometheus-community.github.io/helm-charts"

  name      = "prometheus"
  chart     = "prometheus"
  namespace = kubernetes_namespace.lgtm.id

  set {
    name  = "server.persistentVolume.storageClass"
    value = "nfs-csi"
  }

  set {
    name  = "alertmanager.persistence.storageClass"
    value = "nfs-csi"
  }
}
