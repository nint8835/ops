removed {
  from = kubernetes_namespace.traefik
  lifecycle {
    destroy = false
  }
}

import {
  to = kubernetes_namespace_v1.traefik
  id = "traefik"
}

removed {
  from = kubernetes_namespace.cert_manager
  lifecycle {
    destroy = false
  }
}

import {
  to = kubernetes_namespace_v1.cert_manager
  id = "cert-manager"
}

removed {
  from = kubernetes_namespace.tailscale
  lifecycle {
    destroy = false
  }
}

import {
  to = kubernetes_namespace_v1.tailscale
  id = "tailscale"
}

removed {
  from = kubernetes_namespace.cnpg_system
  lifecycle {
    destroy = false
  }
}

import {
  to = kubernetes_namespace_v1.cnpg_system
  id = "cnpg-system"
}

removed {
  from = kubernetes_namespace.metallb_system
  lifecycle {
    destroy = false
  }
}

import {
  to = kubernetes_namespace_v1.metallb_system
  id = "metallb-system"
}

removed {
  from = kubernetes_namespace.lgtm
  lifecycle {
    destroy = false
  }
}

import {
  to = kubernetes_namespace_v1.lgtm
  id = "lgtm"
}
