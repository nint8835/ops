resource "kubernetes_namespace_v1" "tailscale" {
  metadata {
    name = "tailscale"

    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    }
  }
}

resource "tailscale_acl" "acls" {
  acl = jsonencode({
    tagOwners = {
      "tag:k8s-operator" = []
      "tag:k8s"          = ["tag:k8s-operator"]
    }

    autoApprovers = {
      routes = {
        "10.0.0.0/8"     = ["tag:k8s"]
        "192.168.1.0/24" = ["tag:k8s"]
      }
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
