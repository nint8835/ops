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
  version    = "0.15.3"

  set = [
    {
      name  = "speaker.frr.enabled"
      value = false
    },
    {
      name  = "speaker.resources.requests.memory"
      value = "64Mi"
    },
    {
      name  = "speaker.resources.limits.memory"
      value = "128Mi"
    },
    {
      name  = "controller.resources.requests.memory"
      value = "48Mi"
    },
    {
      name  = "controller.resources.limits.memory"
      value = "96Mi"
    },
  ]
}

module "metallb_configs_hash" {
  source    = "./modules/utils/hash_directory"
  directory = "${path.module}/charts/metallb-configs"
}

resource "helm_release" "metallb_configs" {
  name      = "metallb-configs"
  namespace = kubernetes_namespace.metallb_system.id
  chart     = "${path.module}/charts/metallb-configs"

  set = [
    {
      name  = "_hash"
      value = module.metallb_configs_hash.hash
    },
    {
      name  = "ipRange"
      value = var.lb_ip_range
    },
  ]

  depends_on = [
    helm_release.metallb,
  ]
}
