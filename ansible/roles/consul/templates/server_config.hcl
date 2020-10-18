{% raw %}
bind_addr = "{{ GetInterfaceIP \"eth0\" }}"
client_addr = "127.0.0.1 {{ GetInterfaceIP \"eth0\" }}"
{% endraw %}

datacenter = "{{ consul_datacenter_name }}"
domain = "{{ consul_domain_name }}"

bootstrap_expect = 3
server = true
ui = true

data_dir = "/opt/consul"
log_level = "INFO"

retry_join = [
{% for host in consul_servers %}
{% if host != ansible_default_ipv4.address %}
    "{{ host }}",
{% endif %}
{% endfor %}
]

connect {
  enabled = true
}

telemetry {
  disable_hostname = true
  prometheus_retention_time = "10s"
}
