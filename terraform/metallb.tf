resource "kubernetes_namespace_v1" "metallb_system" {
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
  namespace = kubernetes_namespace_v1.metallb_system.id

  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = "0.16.1"

  max_history = 3

  values = [
    yamlencode({
      frrk8s = { enabled = false }
      speaker = {
        frr = { enabled = false }
        resources = {
          requests = { memory = "64Mi" }
          limits   = { memory = "128Mi" }
        }
      }
      controller = {
        resources = {
          requests = { memory = "48Mi" }
          limits   = { memory = "96Mi" }
        }
      }
    })
  ]
}

module "metallb_configs_hash" {
  source    = "./modules/utils/hash_directory"
  directory = "${path.module}/charts/metallb-configs"
}

resource "helm_release" "metallb_configs" {
  name      = "metallb-configs"
  namespace = kubernetes_namespace_v1.metallb_system.id
  chart     = "${path.module}/charts/metallb-configs"

  max_history = 3

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
