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
        image        = "traefik:v2.4"
        ports        = ["http"]
        network_mode = "host"

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]
      }

      resources {
        memory = 50
      }

      template {
        data = <<EOF
[entryPoints]
  [entryPoints.http]
    address = ":80"

[api]
  dashboard = true

[metrics]
  [metrics.prometheus]
    manualRouting = true

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
        "embassy.enable=true",
        "embassy.title=Traefik (Internal)",
        "embassy.url=http://traefik.internal.bootleg.technology",
        "embassy.icon_url=https://symbols.getvecta.com/stencil_98/35_traefik-icon.290dcd6a8f.svg",
        "embassy.description=In-cluster HTTP request routing",
        "embassy.group=Networking",
      ]
    }

    service {
      name = "traefik-internal-metrics"

      tags = [
        "traefik_internal.enable=true",
        "traefik_internal.http.routers.traefik-internal-metrics.rule=Host(`traefik-metrics.internal.bootleg.technology`)",
        "traefik_internal.http.routers.traefik-internal-metrics.service=prometheus@internal",
      ]
    }
  }
}
