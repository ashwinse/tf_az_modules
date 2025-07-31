resource "azurerm_firewall" "firewall" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id  = var.firewall_policy_id
  zones               = var.zones
  dynamic "ip_configuration" {
    for_each = var.ip_config
    content {
      name                 = ip_configuration.value.name
      subnet_id            = try(format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s/subnets/AzureFirewallSubnet", var.subscription_id, try(ip_configuration.value.resource_group_name, var.resource_group_name), ip_configuration.value.virtual_network_name), null)
      public_ip_address_id = data.azurerm_public_ip.pip[ip_configuration.key].id
    }
  }
  tags = var.tags
}