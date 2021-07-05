job "embassy" {
  datacenters = ["hera"]
  type        = "service"

  group "embassy" {
    constraint {
      attribute = "${node.class}"
      value     = "worker"
    }

    network {
      port "embassy" {
        to = 3000
      }
    }

    service {
      name = "embassy"
      port = "embassy"

      check {
        name     = "Embassy HTTP Check"
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }

      tags = [
        "traefik_internal.enable=true",
        "traefik_internal.http.routers.embassy.rule=Host(`embassy.internal.bootleg.technology`)",
      ]
    }

    task "embassy" {
      driver = "docker"

      config {
        image = "ghcr.io/nint8835/embassy:latest"
        ports = ["embassy"]
      }

      env {
        EMBASSY_CONSUL_ENDPOINT = "consul.service.bootleg.technology:8500"
      }

      resources {
        memory = 25
      }
    }
  }
}
