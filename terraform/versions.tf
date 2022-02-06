terraform {
  required_version = ">= 0.13"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 2.1.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.4.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.7.1"
    }
  }
}
