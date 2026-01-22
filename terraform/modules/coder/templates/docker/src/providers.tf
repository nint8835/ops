provider "docker" {
  host      = "tcp://ares.internal.bootleg.technology:2376"
  cert_path = "/providers/docker/ares"
}
