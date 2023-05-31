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
