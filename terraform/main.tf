terraform {
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~>1.46.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url       = "https://us2.app.sysdig.com"
  sysdig_secure_api_token = "010fd52f-2c9f-4c88-bdfa-19291f898e10"
}

provider "azurerm" {
  features {}
  subscription_id = "4d97ea13-86e4-4081-a304-ebc8551c9861"
  tenant_id       = "e200df82-e280-4dfc-9880-1daa2cabf1ba"
}

provider "azuread" {
  tenant_id = "e200df82-e280-4dfc-9880-1daa2cabf1ba"
}

module "onboarding" {
  source          = "sysdiglabs/secure/azurerm//modules/onboarding"
  version         = "~>0.3"
  subscription_id = "4d97ea13-86e4-4081-a304-ebc8551c9861"
  tenant_id       = "e200df82-e280-4dfc-9880-1daa2cabf1ba"
}

module "config-posture" {
  source                   = "sysdiglabs/secure/azurerm//modules/config-posture"
  version                  = "~>0.3"
  subscription_id          = module.onboarding.subscription_id
  sysdig_secure_account_id = module.onboarding.sysdig_secure_account_id
}

resource "sysdig_secure_cloud_auth_account_feature" "config_posture" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_CONFIG_POSTURE"
  enabled    = true
  components = [module.config-posture.service_principal_component_id]
  depends_on = [module.config-posture]
}
