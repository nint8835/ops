resource "kubernetes_namespace" "lgtm" {
  metadata {
    name = "lgtm"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

resource "cloudflare_dns_record" "grafana" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "grafana.ops.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "helm_release" "grafana" {
  name      = "grafana"
  namespace = kubernetes_namespace.lgtm.id

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "9.0.0"

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

  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "resources.limits.memory"
    value = "256Mi"
  }
}


resource "helm_release" "loki" {
  name      = "loki"
  namespace = kubernetes_namespace.lgtm.id

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.29.0"

  values = [
    <<EOF
loki:
  commonConfig:
    replication_factor: 1
  schemaConfig:
    configs:
      - from: 2024-04-01
        store: tsdb
        object_store: filesystem
        schema: v13
        index:
          prefix: loki_index_
          period: 24h
EOF
  ]

  set {
    name  = "deploymentMode"
    value = "SingleBinary"
  }

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
    name  = "lokiCanary.enabled"
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

  set {
    name  = "resultsCache.enabled"
    value = false
  }

  set {
    name  = "chunksCache.enabled"
    value = false
  }

  set {
    name  = "singleBinary.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "singleBinary.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "gateway.resources.requests.memory"
    value = "16Mi"
  }

  set {
    name  = "gateway.resources.limits.memory"
    value = "32Mi"
  }

  dynamic "set" {
    for_each = toset(["backend", "read", "write"])

    content {
      name  = "${set.key}.replicas"
      value = 0
    }
  }
}

resource "helm_release" "promtail" {
  name      = "promtail"
  namespace = kubernetes_namespace.lgtm.id

  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = "6.16.6"

  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "resources.limits.memory"
    value = "128Mi"
  }
}

resource "helm_release" "prometheus_operator" {
  name      = "prometheus-operator"
  namespace = kubernetes_namespace.lgtm.id

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "72.0.1"

  values = [
    yamlencode({
      prometheus = {
        prometheusSpec = {
          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "nfs-csi"
                accessModes      = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = "1Gi"
                  }
                }
              }
            }
          }
        }
      }
    }),
  ]

  set {
    name  = "grafana.enabled"
    value = false
  }

  set {
    name  = "prometheusOperator.resources.requests.memory"
    value = "48Mi"
  }

  set {
    name  = "prometheusOperator.resources.limits.memory"
    value = "48Mi"
  }

  set {
    name  = "prometheus-node-exporter.resources.requests.memory"
    value = "32Mi"
  }

  set {
    name  = "prometheus-node-exporter.resources.limits.memory"
    value = "32Mi"
  }

  set {
    name  = "kube-state-metrics.resources.requests.memory"
    value = "32Mi"
  }

  set {
    name  = "kube-state-metrics.resources.limits.memory"
    value = "128Mi"
  }

  set {
    name  = "prometheus.prometheusSpec.resources.requests.memory"
    value = "1Gi"
  }

  set {
    name  = "prometheus.prometheusSpec.resources.limits.memory"
    value = "1Gi"
  }

  set {
    name  = "alertmanager.alertmanagerSpec.resources.requests.memory"
    value = "40Mi"
  }

  set {
    name  = "alertmanager.alertmanagerSpec.resources.limits.memory"
    value = "40Mi"
  }
}

resource "helm_release" "metrics_server" {
  name      = "metrics-server"
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.2"

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }
}
