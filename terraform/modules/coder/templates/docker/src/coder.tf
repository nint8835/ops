resource "coder_agent" "agent" {
  arch = data.coder_provisioner.me.arch
  os   = "linux"

  display_apps {
    vscode = false
  }
}

module "git_config" {
  count = data.coder_workspace.me.start_count

  source  = "registry.coder.com/coder/git-config/coder"
  version = "1.0.33"

  agent_id              = coder_agent.agent.id
  allow_username_change = false
}

module "vscode-web" {
  count = data.coder_workspace.me.start_count

  source  = "registry.coder.com/coder/vscode-web/coder"
  version = "1.5.0"

  agent_id       = coder_agent.agent.id
  accept_license = true
}
