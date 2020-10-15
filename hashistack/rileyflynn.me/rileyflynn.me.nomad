job "rileyflynn.me" {
  datacenters = ["dc1"]

  type = "service"

  group "site" {
    count = 1

    network {
      port "http" {}
    }

    task "webserver" {
      driver = "docker" 

      config {
        image = "nint8835/rileyflynn.me"
        ports = ["http"]
      }

    }

    service {
      name = "rileyflynn-me"
      port = "http"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.http.rule=Path(`/`)",
      ]

      check {
        name     = "alive"
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }

    }
  }
}
