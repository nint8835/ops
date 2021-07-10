job "gramfelbot" {
  datacenters = ["hera"]
  type        = "service"

  constraint {
    attribute = "${node.class}"
    value     = "worker"
  }

  # Not sure what kind of network connectivity Elixir / OTP opens up.
  # Keeping internal-only until I can either figure that out or lock down the ports on the bastion host.
  constraint {
    attribute = "${meta.is_cloud}"
    value     = "False"
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

      resources {
        memory = 100
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
