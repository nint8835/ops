resource "kubernetes_namespace" "metallb_system" {
  metadata {
    name = "metallb-system"

    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    }
  }
}

resource "helm_release" "metallb" {
  name      = "metallb"
  namespace = kubernetes_namespace.metallb_system.id

  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = "0.14.9"

  set {
    name  = "speaker.resources.requests.memory"
    value = "64Mi"
  }

  set {
    name  = "speaker.resources.limits.memory"
    value = "128Mi"
  }

  set {
    name  = "speaker.frr.resources.requests.memory"
    value = "64Mi"
  }

  set {
    name  = "speaker.frr.resources.limits.memory"
    value = "128Mi"
  }

  set {
    name  = "speaker.frrSpeaker.resources.requests.memory"
    value = "8Mi"
  }

  set {
    name  = "speaker.frrSpeaker.resources.limits.memory"
    value = "16Mi"
  }

  set {
    name  = "speaker.reloader.resources.requests.memory"
    value = "16Mi"
  }

  set {
    name  = "speaker.reloader.resources.limits.memory"
    value = "32Mi"
  }

  set {
    name  = "controller.resources.requests.memory"
    value = "48Mi"
  }

  set {
    name  = "controller.resources.limits.memory"
    value = "96Mi"
  }
}

resource "kubernetes_manifest" "metallb_ip_pool" {
  depends_on = [helm_release.metallb]

  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "IPAddressPool"
    metadata = {
      name      = "default"
      namespace = kubernetes_namespace.metallb_system.id
    }
    spec = {
      addresses = [
        var.lb_ip_range
      ]
    }
  }
}

resource "kubernetes_manifest" "metallb_announcement" {
  depends_on = [helm_release.metallb]

  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "L2Advertisement"
    metadata = {
      name      = "default"
      namespace = kubernetes_namespace.metallb_system.id
    }
  }
}
