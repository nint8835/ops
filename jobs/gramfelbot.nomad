job "gramfelbot" {
  datacenters = ["hera"]
  type        = "service"

  constraint {
    attribute = "${node.class}"
    value     = "worker"
  }

  group "gramfelbot" {
    restart {
      delay    = "1s"
      interval = "10s"
      mode     = "delay"
    }

    task "gramfelbot" {
      driver = "docker"

      config {
        image             = "ghcr.io/nint8835/gramfelbot:latest"
        memory_hard_limit = 2048
      }

      template {
        data = <<EOF
GRAMFELBOT_TOKEN="{{ key "gramfelbot/discord_token" }}"
EOF

        destination = "secrets/gramfelbot.env"
        env         = true
      }
    }
  }
}
