job "borik" {
  datacenters = ["hera"]
  type        = "service"

  constraint {
    attribute = "${node.class}"
    value     = "worker"
  }

  group "borik" {
    restart {
      delay    = "1s"
      interval = "10s"
      mode     = "delay"
    }

    task "borik" {
      driver = "docker"

      config {
        image             = "ghcr.io/saturn-sh/borik:latest"
        memory_hard_limit = 2048
      }

      template {
        data = <<EOF
BORIK_TOKEN="{{ key "borik/discord_token" }}"
BORIK_STORAGE_TYPE=consul
BORIK_CONSUL_ADDRESS=http://consul.internal.bootleg.technology
EOF

        destination = "secrets/borik.env"
        env         = true
      }
    }
  }
}
