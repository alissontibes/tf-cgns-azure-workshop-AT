#grab ip

# Configure Check Point Provider foar Management API
provider "checkpoint" {
  server   = var.vm_public_ip
  username = "admin"
  password = "Cpwins1!"
  context  = "web_api"
  session_name = "Terraform Session"
}

resource "checkpoint_management_access_rule" "rule1" {
  name = "Cleanup rule"
  layer = "Network"
  position = {top = "top"}
  action = "Accept"
  source = ["Any"]
  destination = ["Any"]
  service = ["Any"]
  content = ["Any"]
  time = ["Any"]
  install_on = ["Policy Targets"]
  track = {
    type = "Log"
    accounting = false
    alert = "none"
    enable_firewall_session = false
    per_connection = true
    per_session = false
  }
  action_settings = {}
  custom_fields = {}
  vpn = "Any"
}
resource "checkpoint_management_publish" "policy-publish" { depends_on= [checkpoint_management_access_rule.rule1] }
resource "checkpoint_management_logout" "logount-cme-login" { depends_on = [checkpoint_management_publish.policy-publish]}

#resource "checkpoint_management_install_policy" "install-policy" {
#  policy_package = "Standard"
#  targets = [""]
#}

terraform {
  backend "remote" {
    organization = "home-atibes"

    workspaces {
      name = "policy"
    }
  }
}
