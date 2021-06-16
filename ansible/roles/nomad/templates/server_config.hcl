server {
    enabled = true
    bootstrap_expect = 3
}

client {
    enabled = true
    node_class = "controller"
    network_interface = "tailscale0"

    options = {
        "user.blacklist" = "root"
    }
    meta = {
        "is_cloud" = "{{ is_cloud | default(false) }}"
    }
}

