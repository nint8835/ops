client {
    enabled = true
    node_class = "worker"
    network_interface = "eth0"

    options = {
        "user.blacklist" = "root"
    }
}
