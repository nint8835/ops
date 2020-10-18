data_dir = "/opt/nomad"
datacenter = "{{ nomad_datacenter_name }}"
{% raw %}
bind_addr = "{{ GetInterfaceIP \"eth0\" }}"
{% endraw %}