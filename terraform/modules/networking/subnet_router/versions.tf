terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.20.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = ">=0.13.7"
    }
  }
}
