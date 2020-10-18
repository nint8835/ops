{% raw %}
bind_addr = "{{ GetInterfaceIP \"eth0\" }}"
client_addr = "127.0.0.1 {{ GetInterfaceIP \"eth0\" }}"
{% endraw %}

bootstrap_expect = 3
server = true
ui = true

data_dir = "/opt/consul"
log_level = "INFO"

domain = "bootleg.technology."


retry_join = [
{% for host in consul_servers %}
{% if host != ansible_default_ipv4.address %}
    "{{ host }}",
{% endif %}
{% endfor %}
]
