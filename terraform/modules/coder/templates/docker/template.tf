resource "coderd_template" "template" {
  name         = "docker"
  display_name = "Docker"
  description  = "Run your workspace in a Docker container on Ares."
  icon         = "/icon/docker.svg"

  versions = [
    {
      name      = "latest"
      directory = "${path.module}/src"
      active    = true
    },
  ]
}
