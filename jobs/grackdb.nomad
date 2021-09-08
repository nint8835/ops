job "grackdb" {
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

  group "grackdb" {
    restart {
      delay    = "1s"
      interval = "10s"
      mode     = "delay"
    }

    network {
      port "grackdb" {
        to = 8081
      }
    }

    service {
      name = "grackdb"
      port = "grackdb"

      check {
        name     = "GrackDB HTTP Check"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }

      tags = [
        "traefik_external.enable=true",
        "traefik_external.http.routers.grackdb.rule=Host(`grackdb.fogo.sh`)",
        "traefik_external.http.routers.grackdb.tls=true",
        "traefik_external.http.routers.grackdb.tls.certresolver=letsencrypt",
      ]
    }

    task "grackdb" {
      driver = "docker"

      config {
        image = "ghcr.io/fogo-sh/grackdb:latest"
        ports = ["grackdb"]

        volumes = [
          "/mnt/shared/grackdb:/grackdb",
        ]
      }

      resources {
        memory = 150
      }

      template {
        data = <<EOF
GRACKDB_JWT_SIGNING_SECRET={{ key "grackdb/jwt_signing_secret" }}
GRACKDB_GITHUB_CLIENT_ID={{ key "grackdb/github_client_id" }}
GRACKDB_GITHUB_CLIENT_SECRET={{ key "grackdb/github_client_secret" }}
GRACKDB_DISCORD_CLIENT_ID={{ key "grackdb/discord_client_id" }}
GRACKDB_DISCORD_CLIENT_SECRET={{ key "grackdb/discord_client_secret" }}
GRACKDB_DISCORD_CALLBACK_URL="https://grackdb.fogo.sh/oauth/discord/callback"
GRACKDB_DB_CONNECTION_STRING="file:/grackdb/grack.db?_fk=1"
EOF

        destination = "secrets/grackdb.env"
        env         = true
      }
    }
  }
}
