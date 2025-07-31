resource "azurerm_network_interface" "nic" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking

  dynamic "ip_configuration" {
    for_each = try(var.ip_configurations, {})

    content {
      name                          = ip_configuration.value.name
      subnet_id                     = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s/subnets/%s", var.subscription_id, var.subnet_resource_group_name, ip_configuration.value.virtual_network_name, ip_configuration.value.subnet_name)
      private_ip_address_allocation = try(ip_configuration.value.private_ip_address_allocation, "Dynamic")
      private_ip_address_version    = lookup(ip_configuration.value, "private_ip_address_version", null)
      private_ip_address            = lookup(ip_configuration.value, "private_ip_address", null)
      primary                       = lookup(ip_configuration.value, "primary", null)
    }
  }
  tags = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}
