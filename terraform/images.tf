locals {
  mirrored_registries = {
    docker-hub = {
      registry_url  = "https://hub.docker.com"
      provider_name = "docker-hub"
    }
    ghcr = {
      registry_url  = "https://ghcr.io"
      provider_name = "github"
    }
    quay = {
      registry_url  = "https://quay.io"
      provider_name = "quay"
    }
    registry-k8s-io = {
      registry_url = "https://registry.k8s.io"
    }
    chainguard = {
      registry_url = "https://cgr.dev"
    }
  }
}

module "registry_mirror" {
  source = "./modules/registry_mirror"

  for_each = local.mirrored_registries

  name          = each.key
  provider_name = try(each.value.provider_name, "harbor")
  registry_url  = each.value.registry_url
}
