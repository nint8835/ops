data "talos_machine_configuration" "config" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = var.role
  machine_secrets  = var.machine_secrets
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
      })
    ],
    var.role == "controlplane" ? [
      file("${path.module}/files/controlplane-scheduling.yaml")
    ] : []
  )
}
