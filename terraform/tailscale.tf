resource "kubernetes_namespace" "tailscale" {
  metadata {
    name = "tailscale"

    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    }
  }
}

resource "tailscale_tailnet_key" "k8s" {
  reusable      = true
  ephemeral     = true
  preauthorized = true
  expiry        = 90 * 24 * 60 * 60
  tags          = ["tag:k8s"]
}

resource "tailscale_tailnet_key" "droplet" {
  reusable      = true
  ephemeral     = true
  preauthorized = true
  expiry        = 90 * 24 * 60 * 60
  tags          = ["tag:droplet"]
}

resource "kubernetes_secret" "tailscale_auth" {
  metadata {
    name      = "tailscale-auth"
    namespace = kubernetes_namespace.tailscale.metadata[0].name
  }

  data = {
    TS_AUTHKEY = tailscale_tailnet_key.k8s.key
  }
}

module "cluster_router" {
  source = "./modules/networking/subnet_router"

  count = 2

  router_name        = "k8s-cluster-router-${count.index}"
  namespace          = kubernetes_namespace.tailscale.id
  ts_auth_key_secret = kubernetes_secret.tailscale_auth.metadata[0].name
  routes             = ["10.0.0.0/8", "192.168.1.0/24"]
  router_group       = "k8s-cluster-router"
}

resource "tailscale_acl" "acls" {
  acl = jsonencode({
    tagOwners = {
      "tag:k8s"     = ["autogroup:admin"]
      "tag:droplet" = ["autogroup:admin"]
    }

    autoApprovers = {
      routes = {
        "10.0.0.0/8"     = ["tag:k8s"]
        "192.168.1.0/24" = ["tag:k8s"]
      }
      exitNode = ["tag:droplet"]
    }

    ssh = [
      {
        action = "check"
        src    = ["autogroup:members"]
        dst    = ["autogroup:self"]
        users  = ["autogroup:nonroot", "root"]
      }
    ]

    grants = [
      {
        src = ["*"]
        dst = ["*"]
        ip  = ["*"]
      }
    ]
  })
}
