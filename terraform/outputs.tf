output "kubeconfig" {
  value       = talos_cluster_kubeconfig.config.kubeconfig_raw
  sensitive   = true
  description = "Kubeconfig for the cluster"
}

output "talosconfig" {
  value       = data.talos_client_configuration.config.talos_config
  sensitive   = true
  description = "Talosconfig for the cluster"
}
