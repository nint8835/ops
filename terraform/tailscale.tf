resource "kubernetes_namespace_v1" "tailscale" {
  metadata {
    name = "tailscale"
  }
}

resource "tailscale_acl" "acls" {
  acl = jsonencode({
    tagOwners = {
      "tag:k8s-operator" = []
      "tag:k8s"          = ["tag:k8s-operator"]
    }

    grants = [
      {
        src = ["*"]
        dst = ["*"]
        ip  = ["*"]
      }
    ]
  })
}

resource "tailscale_oauth_client" "operator" {
  description = "Tailscale Kubernetes Operator"
  scopes = [
    "auth_keys",
    "devices:core",
    "services",
  ]
  tags = ["tag:k8s-operator"]
}

resource "kubernetes_secret_v1" "tailscale_operator" {
  metadata {
    name      = "operator-oauth"
    namespace = kubernetes_namespace_v1.tailscale.metadata[0].name
  }

  data = {
    client_id     = tailscale_oauth_client.operator.id
    client_secret = tailscale_oauth_client.operator.key
  }
}
