resource "coderd_template" "template" {
  name         = "docker"
  display_name = "Docker"
  description  = "Run your workspace in a Docker container on Ares."
  icon         = "/icon/docker.svg"

  versions = [
    {
      name      = "latest-${substr(symbols::utils::hash_directory("${path.module}/src"), 0, 8)}"
      directory = "${path.module}/src"
      active    = true
    },
  ]
}
