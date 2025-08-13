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
  version    = "9.3.2"

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

resource "helm_release" "metrics_server" {
  name      = "metrics-server"
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.13.0"

  set = [
    {
      name  = "args[0]"
      value = "--kubelet-insecure-tls"
    },
  ]
}

resource "helm_release" "victoria_logs" {
  name      = "victoria-logs"
  namespace = kubernetes_namespace.lgtm.id

  repository = "https://victoriametrics.github.io/helm-charts"
  chart      = "victoria-logs-single"
  version    = "0.11.6"

  set = [
    {
      name  = "server.extraArgs.defaultMsgValue"
      value = "No log message"
    },
    {
      name  = "vector.enabled"
      value = true
    },
    {
      name  = "server.persistentVolume.storageClassName"
      value = "nfs-csi"
    },
    {
      name  = "vector.tolerations[0].key"
      value = "node-role.kubernetes.io/control-plane"
    },
    {
      name  = "vector.tolerations[0].operator"
      value = "Exists"
    },
    {
      name  = "vector.tolerations[0].effect"
      value = "NoSchedule"
    }
  ]
}

resource "helm_release" "prometheus_operator_crds" {
  name      = "prometheus-operator-crds"
  namespace = kubernetes_namespace.lgtm.id

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-operator-crds"
  version    = "22.0.2"
}

resource "helm_release" "victoria_metrics_k8s_stack" {
  name      = "victoria-metrics-k8s-stack"
  namespace = kubernetes_namespace.lgtm.id

  repository = "https://victoriametrics.github.io/helm-charts"
  chart      = "victoria-metrics-k8s-stack"
  version    = "0.58.3"

  set = [
    {
      name  = "grafana.enabled"
      value = false
    },
    {
      name  = "vmsingle.spec.storage.storageClassName"
      value = "nfs-csi"
    },
    {
      name  = "victoria-metrics-operator.crds.plain"
      value = false
    }
  ]
}
