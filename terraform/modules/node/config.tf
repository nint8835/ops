data "talos_machine_configuration" "config" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = var.role
  machine_secrets  = var.machine_secrets

  talos_version      = var.talos_config_version
  kubernetes_version = var.kubernetes_version
}

resource "talos_machine_configuration_apply" "node" {
  node = var.ip

  client_configuration        = var.client_configuration
  machine_configuration_input = data.talos_machine_configuration.config.machine_configuration
  config_patches = concat(
    [
      templatefile(
        "${path.module}/templates/install-hostname.yaml.tmpl", {
          hostname = var.name
      }),
      templatefile(
        "${path.module}/templates/topology-labels.yaml.tmpl", {
          region = var.region
          zone   = var.zone
        }
      ),
      yamlencode({
        apiVersion = "v1alpha1"
        kind       = "UnattendedInstallConfig"
        installer = {
          image = var.talos_installer_image
        }
        provisioning = {
          diskSelector = {
            match = "disk.dev_path == \"/dev/sda\""
          }
        }
      })
    ],
    var.role == "controlplane" ? [
      yamlencode({
        apiVersion = "v1alpha1"
        kind       = "KubeAPIServerConfig"
        extraArgs = {
          service-account-issuer   = [var.oidc_issuer_url, var.cluster_endpoint]
          service-account-jwks-uri = "${var.oidc_issuer_url}/openid/v1/jwks"
        }
      })
    ] : []
  )

  depends_on = [proxmox_virtual_environment_vm.vm]
}
