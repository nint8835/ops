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

resource "tailscale_oauth_client" "policy_gitops" {
  description = "Policy GitOps GitHub Action"
  scopes = [
    "devices:core:read",
    "devices:posture_attributes",
    "policy_file",
  ]
}

resource "github_actions_secret" "tailnet" {
  repository      = "ops"
  secret_name     = "TS_TAILNET"
  plaintext_value = var.tailscale_tailnet_name
}

resource "github_actions_secret" "policy_gitops_client_id" {
  repository      = "ops"
  secret_name     = "TS_OAUTH_ID"
  plaintext_value = tailscale_oauth_client.policy_gitops.id
}

resource "github_actions_secret" "policy_gitops_client_secret" {
  repository      = "ops"
  secret_name     = "TS_OAUTH_SECRET"
  plaintext_value = tailscale_oauth_client.policy_gitops.key
}
