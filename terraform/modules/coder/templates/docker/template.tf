resource "coderd_template" "template" {
  name = "docker"

  versions = [
    {
      name      = "latest"
      directory = "${path.module}/src"
      active    = true
    },
  ]
}
