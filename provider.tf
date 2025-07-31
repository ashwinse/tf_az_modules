terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.106.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.50.0"
    }
  }
}

provider "azurerm" {
  # subscription_id = "d10782ce-337e-4126-a4e6-f2a870dafd78"
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id = var.tenant_id
  features {}
}
provider "azuread" {

}
