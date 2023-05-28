output "kubeconfig" {
  value     = data.talos_cluster_kubeconfig.config.kubeconfig_raw
  sensitive = true
}

output "talosconfig" {
  value     = data.talos_client_configuration.config.talos_config
  sensitive = true
}
