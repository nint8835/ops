client {
    enabled = true
    node_class = "worker"
    network_interface = "tailscale0"

    options = {
        "user.blacklist" = "root"
    }

    meta = {
        "is_cloud" = "{{ is_cloud | default(false) }}"
    }
}
