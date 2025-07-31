resource "azurerm_local_network_gateway" "ln_gateway" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = var.gateway_address
  address_space       = var.address_space
  gateway_fqdn        = var.gateway_fqdn
  tags                = var.tags
}