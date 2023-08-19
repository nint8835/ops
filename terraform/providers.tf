provider "netbox" {
  server_url         = var.netbox_url
  api_token          = var.netbox_token
  skip_version_check = true
}

provider "kubernetes" {
  host                   = data.talos_cluster_kubeconfig.config.kubernetes_client_configuration.host
  cluster_ca_certificate = base64decode(data.talos_cluster_kubeconfig.config.kubernetes_client_configuration.ca_certificate)
  client_certificate     = base64decode(data.talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_certificate)
  client_key             = base64decode(data.talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_key)
}

provider "helm" {
  kubernetes {
    host                   = data.talos_cluster_kubeconfig.config.kubernetes_client_configuration.host
    cluster_ca_certificate = base64decode(data.talos_cluster_kubeconfig.config.kubernetes_client_configuration.ca_certificate)
    client_certificate     = base64decode(data.talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(data.talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_key)
  }
}

provider "tailscale" {
  api_key = var.tailscale_api_key
  tailnet = var.tailscale_tailnet_name
}

provider "digitalocean" {
  token = var.digitalocean_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "github" {
  owner = "nint8835"
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = file("github.pem")
  }
}

provider "flux" {
  kubernetes = {
    host                   = data.talos_cluster_kubeconfig.config.kubernetes_client_configuration.host
    cluster_ca_certificate = base64decode(data.talos_cluster_kubeconfig.config.kubernetes_client_configuration.ca_certificate)
    client_certificate     = base64decode(data.talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(data.talos_cluster_kubeconfig.config.kubernetes_client_configuration.client_key)
  }

  git = {
    url = "ssh://git@github.com/nint8835/ops.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}
