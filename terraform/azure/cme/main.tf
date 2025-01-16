#grab ip

# Configure Check Point Provider foar Management API
provider "checkpoint" {
  server   = var.vm_public_ip
  username = "admin"
  password = "Cpwins1!"
  context  = "web_api"
  session_name = "Terraform Session"
  timeout = "60"
}
resource "checkpoint_management_cme_accounts_azure" "azure_account" {
  name           = "azureAccount"
  directory_id   = var.tenant_id
  application_id = var.client_id
  client_secret  = var.client_secret
  subscription   = var.subscription_id
  environment    = "AzureCloud"
  provisioner "local-exec" {
    command = "sleep 60"  # Wait for 60 seconds
  }
}
resource "checkpoint_management_cme_gw_configurations_azure" "gw_config_azure" {
  name                       = "azureGWConfigurations"
  related_account            = "azureAccount"
  version                    = "R81.20"
  base64_sic_key             = "dnBuMTIzNDU2Nzg5MA=="
  policy                     = "Standard"
  x_forwarded_for            = true
  color                      = "blue"

blades {
        ips                          = true
        anti_bot                     = true
        anti_virus                   = true
        https_inspection             = true
        application_control          = false
        autonomous_threat_prevention = false
        content_awareness            = false
        identity_awareness           = false
        ipsec_vpn                    = false
        threat_emulation             = false
        url_filtering                = false
        vpn                          = false
        }
}

resource "checkpoint_management_publish" "cme-publish" { depends_on = [checkpoint_management_cme_gw_configurations_azure.gw_config_azure]}
#resource "checkpoint_management_install_policy" "install-policy" {
#  policy_package = "Standard"
#  targets = [""]
#}
resource "checkpoint_management_logout" "logount-cme-login" { depends_on = [checkpoint_management_publish.cme-publish]}


terraform {
  backend "remote" {
    organization = "home-atibes"

    workspaces {
      name = "cme"
    }
  }
}
