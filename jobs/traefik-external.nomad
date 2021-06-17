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
          "/opt/letsencrypt/acme.json:/acme.json"
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
      ]
    }
  }
}
