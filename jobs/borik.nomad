job "borik" {
  datacenters = ["hera"]
  type        = "service"

  constraint {
    attribute = "${node.class}"
    value     = "worker"
  }

  group "borik" {
    task "borik" {
      driver = "docker"

      config {
        image        = "ghcr.io/saturn-sh/borik:latest"
      }

      template {
        data = <<EOF
BORIK_TOKEN="{{ key "borik/discord_token" }}"
EOF
        destination = "secrets/borik.env"
        env = true
      }
    }
  }
}
