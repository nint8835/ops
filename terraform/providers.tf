provider "kubernetes" {
  host                   = talos_cluster_kubeconfig.config.kubernetes_client_configuration.host
  cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.config.kubernetes_client_configuration.ca_certificate)
  client_certificate     = base64decode(talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_certificate)
  client_key             = base64decode(talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_key)
}

provider "helm" {
  kubernetes = {
    host                   = talos_cluster_kubeconfig.config.kubernetes_client_configuration.host
    cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.config.kubernetes_client_configuration.ca_certificate)
    client_certificate     = base64decode(talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_key)
  }
}

provider "tailscale" {
  api_key = var.tailscale_api_key
  tailnet = var.tailscale_tailnet_name
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "http" "cloudflare_account_token" {
  url = "https://api.cloudflare.com/client/v4/accounts/${var.cloudflare_account_id}/tokens/verify"

  request_headers = {
    Accept        = "application/json"
    Authorization = "Bearer ${var.cloudflare_api_token}"
  }
  request_timeout_ms = 30000

  lifecycle {
    postcondition {
      condition = self.status_code == 200 && try(
        jsondecode(self.response_body).success && jsondecode(self.response_body).result.status == "active",
        false
      )
      error_message = "Cloudflare must verify the configured account API token as active."
    }
  }
}

provider "aws" {
  alias      = "r2"
  region     = "auto"
  access_key = jsondecode(data.http.cloudflare_account_token.response_body).result.id
  secret_key = sha256(var.cloudflare_api_token)

  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

  endpoints {
    s3 = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
  }
}

provider "github" {
  owner = "nint8835"
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = file("${path.module}/github.pem")
  }
}

provider "flux" {
  kubernetes = {
    host                   = talos_cluster_kubeconfig.config.kubernetes_client_configuration.host
    cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.config.kubernetes_client_configuration.ca_certificate)
    client_certificate     = base64decode(talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_key)
  }

  git = {
    url = "ssh://git@github.com/nint8835/ops.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}

provider "proxmox" {
  username = var.proxmox_username
  password = var.proxmox_password
  endpoint = "https://proxy.hosts.bootleg.technology"
  insecure = true
}
