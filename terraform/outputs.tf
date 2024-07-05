output "kubeconfig" {
  value       = data.talos_cluster_kubeconfig.config.kubeconfig_raw
  sensitive   = true
  description = "Kubeconfig for the cluster"
}

output "talosconfig" {
  value       = data.talos_client_configuration.config.talos_config
  sensitive   = true
  description = "Talosconfig for the cluster"
}

output "bastion_ip" {
  value       = module.bastion_host.public_ip
  description = "Public IP of the bastion host"
}
