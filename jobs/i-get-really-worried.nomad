job "i-get-really-worried" {
  datacenters = ["hera"]
  type        = "service"

  constraint {
    attribute = "${node.class}"
    value     = "worker"
  }

  constraint {
    attribute = "${meta.is_cloud}"
    value     = "False"
  }

  group "i-get-really-worried" {
    restart {
      delay    = "1s"
      interval = "10s"
      mode     = "delay"
    }

    task "i-get-really-worried" {
      driver = "docker"

      config {
        image             = "ghcr.io/nint8835/i-get-really-worried:latest"
        memory_hard_limit = 2048
      }

      template {
        data = <<EOF
IGRW_TOKEN="{{ key "i-get-really-worried/discord_token" }}"
EOF

        destination = "secrets/i-get-really-worried.env"
        env         = true
      }
    }
  }
}
