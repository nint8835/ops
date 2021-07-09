job "traefik-external" {
  datacenters = ["hera"]
  type        = "service"

  constraint {
    attribute = "${node.class}"
    value     = "worker"
  }

  constraint {
    attribute = "${meta.is_cloud}"
    value     = "True"
  }

  group "traefik" {
    network {
      port "http" {
        static = 80
      }

      port "https" {
        static = 443
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:v2.4"
        ports        = ["http", "https"]
        network_mode = "host"

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
          "/opt/letsencrypt/acme.json:/acme.json",
        ]
      }

      template {
        data = <<EOF
[entryPoints]
  [entryPoints.http]
    address = ":80"

    [entryPoints.http.http]
      [entryPoints.http.http.redirections]
        [entryPoints.http.http.redirections.entryPoint]
          to = "websecure"
          scheme = "https"
  
  [entryPoints.websecure]
    address = ":443"

[api]
  dashboard = true

[certificateResolvers.letsencrypt.acme]
  email = "riley@rileyflynn.me"

  [certificatesResolvers.letsencrypt.acme.httpChallenge]
    entryPoint = "http"

[metrics]
  [metrics.prometheus]
    manualRouting = true

[providers.consulCatalog]
    prefix           = "traefik_external"
    exposedByDefault = false

    [providers.consulCatalog.endpoint]
      address = "127.0.0.1:8500"
      scheme  = "http"
EOF

        destination = "local/traefik.toml"
      }
    }

    service {
      name = "traefik-external"
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
      name = "traefik-external-dashboard"
      port = "https"

      tags = [
        "traefik_external.enable=true",
        "traefik_external.http.routers.traefik-dashboard.rule=Host(`traefik-external.internal.bootleg.technology`)",
        "traefik_external.http.routers.traefik-dashboard.service=api@internal",
        "traefik_external.http.routers.traefik-dashboard.entrypoints=websecure",
        "traefik_external.http.routers.traefik-dashboard.middlewares=dashboard-ipwhitelist",
        "traefik_external.http.middlewares.dashboard-ipwhitelist.ipwhitelist.sourcerange=100.0.0.0/8",
        "traefik_internal.enable=true",
        "traefik_internal.http.routers.traefik-external-dashboard.rule=Host(`traefik-external.internal.bootleg.technology`)",
        "embassy.enable=true",
        "embassy.title=Traefik (External)",
        "embassy.url=http://traefik-external.internal.bootleg.technology",
        "embassy.icon_url=https://symbols.getvecta.com/stencil_98/35_traefik-icon.290dcd6a8f.svg",
        "embassy.description=Public HTTP request routing",
        "embassy.group=Networking",
      ]
    }

    service {
      name = "traefik-external-metrics"
      port = "https"

      tags = [
        "traefik_external.enable=true",
        "traefik_external.http.routers.traefik-external-metrics.rule=Host(`traefik-external-metrics.internal.bootleg.technology`)",
        "traefik_external.http.routers.traefik-external-metrics.service=prometheus@internal",
        "traefik_external.http.routers.traefik-external-metrics.entrypoints=websecure",
        "traefik_external.http.routers.traefik-external-metrics.middlewares=traefik-external-metrics-ipwhitelist",
        "traefik_external.http.middlewares.traefik-external-metrics-ipwhitelist.ipwhitelist.sourcerange=100.0.0.0/8",
        "traefik_internal.enable=true",
        "traefik_internal.http.routers.traefik-external-metrics.rule=Host(`traefik-external-metrics.internal.bootleg.technology`)",
      ]
    }
  }
}
