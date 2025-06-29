removed {
  from = kubernetes_manifest.metallb_announcement

  lifecycle {
    destroy = false
  }
}

removed {
  from = kubernetes_manifest.metallb_ip_pool

  lifecycle {
    destroy = false
  }
}
