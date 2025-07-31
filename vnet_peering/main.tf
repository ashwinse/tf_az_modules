terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">=3.52.0"
      configuration_aliases = [azurerm.hub]
    }
  }
}
resource "azurerm_virtual_network_peering" "peer_spoketohub" {
  count                = var.envt == "spoke" ? 1 : 0
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.spoke_virtual_network_name
  # remote_virtual_network_id = var.remote_virtual_network_id
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet_hub[0].id
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit
  allow_virtual_network_access = var.allow_virtual_network_access
  use_remote_gateways          = var.use_remote_gateways
}

data "azurerm_virtual_network" "vnet_hub" {
  count               = var.envt == "spoke" ? 1 : 0
  provider            = azurerm.hub
  name                = var.hub_virtual_network_name
  resource_group_name = var.hub_resource_group_name
}

resource "azurerm_virtual_network_peering" "peer_hubtospoke" {
  count                        = var.envt == "hub" ? 1 : 0
  provider                     = azurerm.hub
  name                         = var.name
  resource_group_name          = var.hub_resource_group_name
  virtual_network_name         = var.hub_virtual_network_name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet_spoke[0].id
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit
  allow_virtual_network_access = var.allow_virtual_network_access
  use_remote_gateways          = var.use_remote_gateways
}

data "azurerm_virtual_network" "vnet_spoke" {
  count               = var.envt == "hub" ? 1 : 0
  name                = var.spoke_virtual_network_name
  resource_group_name = var.resource_group_name
}

