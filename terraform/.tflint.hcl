plugin "terraform" {
  enabled = true
  preset = "recommended"
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = false
}

rule "terraform_unused_required_providers" {
  enabled = true
}
