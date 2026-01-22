resource "coder_agent" "agent" {
  arch = data.coder_provisioner.me.arch
  os   = "linux"
}

module "git-config" {
  count = data.coder_workspace.me.start_count

  source  = "registry.coder.com/coder/git-config/coder"
  version = "1.0.32"

  agent_id              = coder_agent.agent.id
  allow_username_change = false
}
