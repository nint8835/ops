data "cloudflare_zone" "bootleg_technology" {
  name = "bootleg.technology"
}

resource "cloudflare_record" "testing" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "testing"
  value   = module.bastion_host.public_ip
  type    = "A"
}

resource "kubernetes_deployment" "test_service" {
  metadata {
    namespace = "default"
    name      = "testing"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "testing"
      }
    }

    template {
      metadata {
        labels = {
          app = "testing"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "test_service" {
  metadata {
    name      = "testing"
    namespace = "default"
  }

  spec {
    selector = {
      app = "testing"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_ingress_v1" "test_service" {
  metadata {
    name      = "testing"
    namespace = "default"

    annotations = {
      "cert-manager.io/cluster-issuer"                   = "letsencrypt-staging"
      "traefik.ingress.kubernetes.io/router.middlewares" = "traefik-https-redirect@kubernetescrd"
    }
  }

  spec {

    rule {
      host = "testing.bootleg.technology"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.test_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    tls {
      secret_name = "testing-cert"
      hosts = [
        "testing.bootleg.technology"
      ]
    }
  }
}
