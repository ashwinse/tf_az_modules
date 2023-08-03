resource "azurerm_virtual_network" "vnet" {
  name                    = var.name
  address_space           = var.address_space
  location                = var.location
  resource_group_name     = var.resource_group_name
  tags                    = var.tags
  edge_zone               = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes
  dynamic "ddos_protection_plan" {
    for_each = var.is_ddos_protection_plan_enable == true ? [1] : []
    content {
      id     = var.ddos_protection_plan_id
      enable = var.is_ddos_protection_plan_enable
    }
  }
}