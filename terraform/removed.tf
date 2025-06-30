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

removed {
  from = kubernetes_manifest.letsencrypt_staging_issuer

  lifecycle {
    destroy = false
  }
}

removed {
  from = kubernetes_manifest.letsencrypt_issuer

  lifecycle {
    destroy = false
  }
}

removed {
  from = kubernetes_manifest.traefik_https_redirect

  lifecycle {
    destroy = false
  }
}

removed {
  from = kubernetes_manifest.traefik_dashboard_auth

  lifecycle {
    destroy = false
  }
}

removed {
  from = kubernetes_manifest.traefik_dashboard

  lifecycle {
    destroy = false
  }
}
