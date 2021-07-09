job "scribe" {
  datacenters = ["hera"]
  type        = "service"

  constraint {
    attribute = "${node.class}"
    value     = "worker"
  }

  group "scribe" {
    restart {
      delay    = "1s"
      interval = "10s"
      mode     = "delay"
    }

    task "scribe" {
      driver = "docker"

      config {
        image = "ghcr.io/nint8835/scribe:latest"

        volumes = [
          "/mnt/shared/scribe:/scribe",
        ]
      }

      template {
        data = <<EOF
SCRIBE_TOKEN="{{ key "scribe/discord_token" }}"
SCRIBE_DB_PATH="/scribe/quotes.sqlite"
EOF

        destination = "secrets/scribe.env"
        env         = true
      }
    }
  }
}
