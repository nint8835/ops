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

resource "tailscale_federated_identity" "operator" {
  description = "Tailscale Kubernetes Operator"
  issuer      = "https://${local.oidc_domain}"
  subject     = "system:serviceaccount:${kubernetes_namespace_v1.tailscale.metadata[0].name}:operator"
  scopes = [
    "auth_keys",
    "devices:core",
    "services",
  ]
  tags = ["tag:k8s-operator"]

  depends_on = [
    tailscale_acl.acls,
    aws_s3_object.cluster_oidc,
    cloudflare_r2_custom_domain.cluster_oidc,
  ]
}

resource "kubernetes_config_map_v1" "tailscale_operator" {
  metadata {
    name      = "operator-federation"
    namespace = kubernetes_namespace_v1.tailscale.metadata[0].name

    labels = {
      "reconcile.fluxcd.io/watch" = "Enabled"
    }
  }

  data = {
    "values.yaml" = yamlencode({
      oauth = {
        clientId = tailscale_federated_identity.operator.id
        audience = tailscale_federated_identity.operator.audience
      }
    })
  }
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
