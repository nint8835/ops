job "traefik-internal" {
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

  group "traefik" {
    network {
      port "http" {
        static = 80
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:v2.2"
        ports        = ["http"]
        network_mode = "host"

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]
      }

      template {
        data = <<EOF
[entryPoints]
    [entryPoints.http]
    address = ":80"

[api]
    dashboard = true

# Enable Consul Catalog configuration backend.
[providers.consulCatalog]
    prefix           = "traefik_internal"
    exposedByDefault = false

    [providers.consulCatalog.endpoint]
      address = "127.0.0.1:8500"
      scheme  = "http"
EOF

        destination = "local/traefik.toml"
      }
    }

    service {
      name = "traefik-internal"
      port = "http"

      check {
        name     = "Traefik Reachable"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    service {
      name = "traefik-internal-dashboard"

      tags = [
        "traefik_internal.enable=true",
        "traefik_internal.http.routers.api.rule=Host(`traefik.internal.bootleg.technology`)",
        "traefik_internal.http.routers.api.service=api@internal",
      ]
    }
  }
}
