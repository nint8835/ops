data_dir = "/opt/nomad"
datacenter = "{{ nomad_datacenter_name }}"
{% raw %}
bind_addr = "{{ GetInterfaceIP \"eth0\" }}"
{% endraw %}

telemetry {
  collection_interval = "1s"
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}
