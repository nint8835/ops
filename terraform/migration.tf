removed {
  from = kubernetes_secret.certmanager_cloudflare_token
  lifecycle {
    destroy = false
  }
}

import {
  to = kubernetes_secret_v1.certmanager_cloudflare_token
  id = "cert-manager/cloudflare-api-token"
}

removed {
  from = kubernetes_secret.traefik_dashboard_auth
  lifecycle {
    destroy = false
  }
}

import {
  to = kubernetes_secret_v1.traefik_dashboard_auth
  id = "traefik/traefik-dashboard-auth"
}

removed {
  from = kubernetes_secret.sops_age
  lifecycle {
    destroy = false
  }
}

import {
  to = kubernetes_secret_v1.sops_age
  id = "flux-system/sops-age"
}

removed {
  from = kubernetes_secret.tailscale_auth
  lifecycle {
    destroy = false
  }
}

import {
  to = kubernetes_secret_v1.tailscale_auth
  id = "tailscale/tailscale-auth"
}
