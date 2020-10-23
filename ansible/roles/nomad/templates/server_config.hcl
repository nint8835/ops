server {
    enabled = true
    bootstrap_expect = 3
}

client {
    enabled = true
    node_class = "controller"
    network_interface = "eth0"

    options = {
        "user.blacklist" = "root"
    }
}

