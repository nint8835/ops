resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "flux" {
  repository = "ops"
  title      = "Flux"
  key        = tls_private_key.flux.public_key_openssh
  read_only  = false
}

resource "flux_bootstrap_git" "bootstrap" {
  depends_on = [github_repository_deploy_key.flux]

  path    = "flux"
  version = "v2.7.5"
  components_extra = [
    "image-reflector-controller",
    "image-automation-controller",
  ]

  kustomization_override = file("${path.module}/files/flux-kustomization.yaml")
}

resource "kubernetes_secret_v1" "sops_age" {
  depends_on = [flux_bootstrap_git.bootstrap]

  metadata {
    name      = "sops-age"
    namespace = "flux-system"
  }

  data = {
    "age.agekey" = var.age_secret_key
  }
}
