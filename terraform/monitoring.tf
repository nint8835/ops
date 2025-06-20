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
  version    = "9.2.7"

  set = [
    {
      name  = "persistence.enabled"
      value = true
    },
    {
      name  = "persistence.storageClassName"
      value = "nfs-csi"
    },
    {
      name  = "ingress.enabled"
      value = true
    },
    {
      name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
      value = "letsencrypt"
    },
    {
      name  = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.middlewares"
      value = "traefik-https-redirect@kubernetescrd"
    },
    {
      name  = "ingress.hosts[0]"
      value = "grafana.ops.bootleg.technology"
    },
    {
      name  = "ingress.tls[0].hosts[0]"
      value = "grafana.ops.bootleg.technology"
    },
    {
      name  = "ingress.tls[0].secretName"
      value = "grafana-tls"
    },
    {
      name  = "grafana\\.ini.server.root_url"
      value = "https://grafana.ops.bootleg.technology"
    },
    {
      name  = "resources.requests.memory"
      value = "128Mi"
    },
    {
      name  = "resources.limits.memory"
      value = "256Mi"
    },
  ]
}


resource "helm_release" "loki" {
  name      = "loki"
  namespace = kubernetes_namespace.lgtm.id

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.30.1"

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

  set = [
    {
      name  = "deploymentMode"
      value = "SingleBinary"
    },
    {
      name  = "singleBinary.replicas"
      value = 1
    },
    {
      name  = "singleBinary.persistence.storageClass"
      value = "nfs-csi"
    },
    {
      name  = "loki.commonConfig.replication_factor"
      value = 1
    },
    {
      name  = "loki.storage.type"
      value = "filesystem"
    },
    {
      name  = "loki.auth_enabled"
      value = false
    },
    {
      name  = "lokiCanary.enabled"
      value = false
    },
    {
      name  = "test.enabled"
      value = false
    },
    {
      name  = "monitoring.selfMonitoring.enabled"
      value = false
    },
    {
      name  = "monitoring.selfMonitoring.grafanaAgent.installOperator"
      value = false
    },
    {
      name  = "resultsCache.enabled"
      value = false
    },
    {
      name  = "chunksCache.enabled"
      value = false
    },
    {
      name  = "singleBinary.resources.requests.memory"
      value = "128Mi"
    },
    {
      name  = "singleBinary.resources.limits.memory"
      value = "256Mi"
    },
    {
      name  = "gateway.resources.requests.memory"
      value = "16Mi"
    },
    {
      name  = "gateway.resources.limits.memory"
      value = "32Mi"
    },
    {
      name  = "backend.replicas"
      value = 0
    },
    {
      name  = "read.replicas"
      value = 0
    },
    {
      name  = "write.replicas"
      value = 0
    },
  ]
}

resource "helm_release" "promtail" {
  name      = "promtail"
  namespace = kubernetes_namespace.lgtm.id

  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = "6.17.0"

  set = [
    {
      name  = "resources.requests.memory"
      value = "128Mi"
    },
    {
      name  = "resources.limits.memory"
      value = "128Mi"
    },
  ]
}

resource "helm_release" "prometheus_operator" {
  name      = "prometheus-operator"
  namespace = kubernetes_namespace.lgtm.id

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "75.4.0"

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

  set = [
    {
      name  = "grafana.enabled"
      value = false
    },
    {
      name  = "prometheusOperator.resources.requests.memory"
      value = "48Mi"
    },
    {
      name  = "prometheusOperator.resources.limits.memory"
      value = "48Mi"
    },
    {
      name  = "prometheus-node-exporter.resources.requests.memory"
      value = "32Mi"
    },
    {
      name  = "prometheus-node-exporter.resources.limits.memory"
      value = "32Mi"
    },
    {
      name  = "kube-state-metrics.resources.requests.memory"
      value = "32Mi"
    },
    {
      name  = "kube-state-metrics.resources.limits.memory"
      value = "196Mi"
    },
    {
      name  = "prometheus.prometheusSpec.resources.requests.memory"
      value = "1Gi"
    },
    {
      name  = "prometheus.prometheusSpec.resources.limits.memory"
      value = "1Gi"
    },
    {
      name  = "alertmanager.alertmanagerSpec.resources.requests.memory"
      value = "40Mi"
    },
    {
      name  = "alertmanager.alertmanagerSpec.resources.limits.memory"
      value = "40Mi"
    },
  ]
}

resource "helm_release" "metrics_server" {
  name      = "metrics-server"
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.2"

  set = [
    {
      name  = "args[0]"
      value = "--kubelet-insecure-tls"
    },
  ]
}
