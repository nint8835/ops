service {
  name = "node-exporter"
  port = 9100

  check {
    name     = "Metrics Reachable"
    http     = "http://localhost:9100/metrics"
    interval = "10s"
    timeout  = "2s"
  }
}
