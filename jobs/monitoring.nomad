job "monitoring" {
  datacenters = ["hera"]
  type        = "service"

  group "stats" {
    constraint {
      attribute = "${node.class}"
      value     = "worker"
    }

    constraint {
      attribute = "${meta.is_cloud}"
      value = "False"
    }

    network {
      port "prometheus_ui" {
        to = 9090
      }
      port "consul_exporter" {
        to = 9107
      }
    }

    service {
      name = "prometheus"
      port = "prometheus_ui"

      check {
        name     = "Prometheus HTTP Check"
        type     = "http"
        path     = "/-/healthy"
        interval = "10s"
        timeout  = "2s"
      }

      tags = [
        "traefik_internal.enable=true",
        "traefik_internal.http.routers.prometheus.rule=Host(`prometheus.internal.bootleg.technology`)",
      ]
    }

    service {
      name = "consul-exporter"
      port = "consul_exporter"

      check {
        name = "consul-exporter HTTP Check"
        type = "http"
        path = "/metrics"
        interval = "10s"
        timeout = "2s"
      }
    }

    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/prometheus:latest"
        ports = ["prometheus_ui"]

        args = [
          "--storage.tsdb.retention.time=90d",
          # Stock Prometheus args, provided to allow adding custom args
          "--config.file=/etc/prometheus/prometheus.yml",
          "--storage.tsdb.path=/prometheus",
          "--web.console.libraries=/usr/share/prometheus/console_libraries",
          "--web.console.templates=/usr/share/prometheus/consoles"
        ]

        volumes = [
          "local/prometheus.yml:/etc/prometheus/prometheus.yml",
          "/mnt/shared/prometheus:/prometheus"
        ]
      }

      template {
        change_mode = "noop"
        destination = "local/prometheus.yml"

        data = <<EOF
---
global:
  scrape_interval:     5s
  evaluation_interval: 5s

scrape_configs:
  - job_name: 'nomad'
    consul_sd_configs:
    - server: '{{ env "NOMAD_IP_prometheus_ui" }}:8500'
      services: ['nomad-client', 'nomad']

    relabel_configs:
    - source_labels: ['__meta_consul_tags']
      regex: '(.*)http(.*)'
      action: keep

    metrics_path: /v1/metrics
    params:
      format: ['prometheus']

  - job_name: 'consul'
    consul_sd_configs:
    - server: '{{ env "NOMAD_IP_prometheus_ui" }}:8500'
      services: ['consul']
    
    relabel_configs:
    - source_labels: ['__address__']
      separator:     ':'
      regex:         '(.*):(8300)'
      target_label:  '__address__'
      replacement:   '${1}:8500'

    metrics_path: /v1/agent/metrics
    params:
      format: ['prometheus']
  
  - job_name: 'consul-exporter'
    consul_sd_configs:
    - server: '{{ env "NOMAD_IP_prometheus_ui" }}:8500'
      services: ['consul-exporter']

  - job_name: 'node-exporter'
    consul_sd_configs:
    - server: '{{ env "NOMAD_IP_prometheus_ui" }}:8500'
      services: ['node-exporter']

    metrics_path: /metrics
  
  - job_name: 'traefik-internal'
    static_configs:
      - targets:
        - traefik-metrics.internal.bootleg.technology
  
  - job_name: 'traefik-external'
    static_configs:
      - targets:
        - traefik-external-metrics.internal.bootleg.technology
  
EOF
      }
    }

    task "consul_exporter" {
      driver = "docker"

      config {
        image = "prom/consul-exporter:latest"
        ports = ["consul_exporter"]

        args = [
          "--consul.server=consul.service.bootleg.technology:8500"
        ]
      }
    }
  }

  group "visualization" {
    constraint {
      attribute = "${node.class}"
      value     = "worker"
    }

    constraint {
      attribute = "${meta.is_cloud}"
      value = "False"
    }

    network {
      port "grafana_ui" {
        to = 3000
      }
    }

    service {
      name = "grafana"
      port = "grafana_ui"

      check {
        name     = "Grafana HTTP Check"
        type     = "http"
        path     = "/api/health"
        interval = "10s"
        timeout  = "2s"
      }

      tags = [
        "traefik_internal.enable=true",
        "traefik_internal.http.routers.grafana.rule=Host(`dashboard.internal.bootleg.technology`)",
      ]
    }

    task "grafana" {
      driver = "docker"

      config {
        image = "grafana/grafana:latest"
        ports = ["grafana_ui"]

        volumes = [
          "/mnt/shared/grafana:/var/lib/grafana"
        ]
      }
    }
  }
}
