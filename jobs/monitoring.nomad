job "monitoring" {
  datacenters = ["hera"]
  type        = "service"

  group "stats" {
    constraint {
      attribute = "${node.class}"
      value     = "worker"
    }

    network {
      port "prometheus_ui" {
        to = 9090
      }
    }

    ephemeral_disk {
      migrate = true
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
    }

    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/prometheus:latest"
        ports = ["prometheus_ui"]

        volumes = [
          "local/prometheus.yml:/etc/prometheus/prometheus.yml",
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

    scrape_interval: 5s
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

    scrape_interval: 5s
    metrics_path: /v1/agent/metrics
    params:
      format: ['prometheus']
  - job_name: 'node-exporter'
    consul_sd_configs:
    - server: '{{ env "NOMAD_IP_prometheus_ui" }}:8500'
      services: ['node-exporter']

    scrape_interval: 5s
    metrics_path: /metrics
EOF
      }
    }
  }
}
