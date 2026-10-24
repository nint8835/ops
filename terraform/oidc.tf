locals {
  oidc_domain = "oidc.ops.bootleg.technology"
}

resource "cloudflare_r2_bucket" "cluster_oidc" {
  account_id = var.cloudflare_account_id
  name       = "${var.cluster_name}-oidc"
}

resource "cloudflare_r2_custom_domain" "cluster_oidc" {
  account_id  = var.cloudflare_account_id
  bucket_name = cloudflare_r2_bucket.cluster_oidc.name
  domain      = local.oidc_domain
  zone_id     = local.zone_ids["bootleg.technology"]
  enabled     = true
}

data "http" "cluster_oidc" {
  for_each = toset([
    ".well-known/openid-configuration",
    "openid/v1/jwks",
  ])

  url             = "${talos_cluster_kubeconfig.config.kubernetes_client_configuration.host}/${each.value}"
  ca_cert_pem     = base64decode(talos_cluster_kubeconfig.config.kubernetes_client_configuration.ca_certificate)
  client_cert_pem = base64decode(talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_certificate)
  client_key_pem  = base64decode(talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_key)

  request_headers = {
    Accept = "application/json, application/jwk-set+json"
  }
  request_timeout_ms = 30000

  lifecycle {
    postcondition {
      condition     = self.status_code == 200 && can(jsondecode(self.response_body))
      error_message = "The cluster OIDC endpoint must return HTTP 200 with a JSON document."
    }
  }
}

resource "aws_s3_object" "cluster_oidc" {
  provider = aws.r2
  for_each = {
    for path, document in data.http.cluster_oidc : path => {
      content      = document.response_body
      content_type = document.response_headers["Content-Type"]
    }
  }

  bucket        = cloudflare_r2_bucket.cluster_oidc.name
  key           = each.key
  content       = each.value.content
  content_type  = each.value.content_type
  cache_control = "public, max-age=300"
  source_hash   = sha256(each.value.content)
}
