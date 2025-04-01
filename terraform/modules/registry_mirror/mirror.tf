resource "harbor_registry" "registry" {
  name          = var.name
  endpoint_url  = var.registry_url
  provider_name = var.provider_name
}

resource "harbor_project" "project" {
  name                   = var.name
  public                 = true
  registry_id            = harbor_registry.registry.registry_id
  vulnerability_scanning = false
}

resource "harbor_retention_policy" "retention_policy" {
  scope    = harbor_project.project.id
  schedule = "Daily"

  rule {
    n_days_since_last_pull = 180
    repo_matching          = "**"
    tag_matching           = "**"
  }
}
