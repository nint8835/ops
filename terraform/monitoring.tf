resource "kubernetes_namespace_v1" "lgtm" {
  metadata {
    name = "lgtm"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

resource "helm_release" "grafana" {
  name      = "grafana"
  namespace = kubernetes_namespace_v1.lgtm.id

  repository = "https://grafana-community.github.io/helm-charts"
  chart      = "grafana"
  version    = "13.2.5"

  max_history = 3

  values = [
    yamlencode({
      persistence = {
        enabled          = true
        storageClassName = "nfs-csi"
      }
      ingress = {
        enabled = true
        annotations = {
          "cert-manager.io/cluster-issuer"                   = "letsencrypt"
          "traefik.ingress.kubernetes.io/router.middlewares" = "traefik-https-redirect@kubernetescrd"
        }
        hosts = ["grafana.ops.bootleg.technology"]
        tls = [{
          hosts      = ["grafana.ops.bootleg.technology"]
          secretName = "grafana-tls"
        }]
      }
      "grafana.ini" = {
        server = { root_url = "https://grafana.ops.bootleg.technology" }
      }
      resources = {
        requests = { memory = "256Mi" }
        limits   = { memory = "786Mi" }
      }
    })
  ]
}

resource "helm_release" "metrics_server" {
  name      = "metrics-server"
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.14.0"

  max_history = 3

  set = [
    {
      name  = "args[0]"
      value = "--kubelet-insecure-tls"
    },
  ]
}

resource "helm_release" "victoria_logs" {
  name      = "victoria-logs"
  namespace = kubernetes_namespace_v1.lgtm.id

  repository = "https://victoriametrics.github.io/helm-charts"
  chart      = "victoria-logs-single"
  version    = "0.13.9"

  max_history = 3

  values = [
    yamlencode({
      server = {
        extraArgs        = { defaultMsgValue = "No log message" }
        persistentVolume = { storageClassName = "nfs-csi" }
      }
      vector = {
        enabled = true
        tolerations = [{
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Exists"
          effect   = "NoSchedule"
        }]
      }
    })
  ]
}

resource "helm_release" "prometheus_operator_crds" {
  name      = "prometheus-operator-crds"
  namespace = kubernetes_namespace_v1.lgtm.id

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-operator-crds"
  version    = "32.0.0"

  max_history = 3
}

resource "helm_release" "victoria_metrics_k8s_stack" {
  name      = "victoria-metrics-k8s-stack"
  namespace = kubernetes_namespace_v1.lgtm.id

  repository = "https://victoriametrics.github.io/helm-charts"
  chart      = "victoria-metrics-k8s-stack"
  version    = "0.93.0"

  max_history = 3

  values = [
    yamlencode({
      grafana = { enabled = false }
      vmsingle = {
        spec = {
          storage = { storageClassName = "nfs-csi" }
        }
      }
      "victoria-metrics-operator" = {
        crds = { plain = false }
      }
    })
  ]

  depends_on = [helm_release.prometheus_operator_crds]
}
