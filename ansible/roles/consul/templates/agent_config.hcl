{% raw %}
bind_addr = "{{ GetInterfaceIP \"tailscale0\" }}"
client_addr = "127.0.0.1 {{ GetInterfaceIP \"eth0\" }} {{ GetInterfaceIP \"tailscale0\" }}"
{% endraw %}

datacenter = "{{ consul_datacenter_name }}"
domain = "{{ consul_domain_name }}"

server = false
ui = false

data_dir = "/opt/consul"
log_level = "INFO"

retry_join = [
{% for host in consul_servers %}
{% if host != ansible_tailscale0.ipv4.address %}
    "{{ host }}",
{% endif %}
{% endfor %}
]
