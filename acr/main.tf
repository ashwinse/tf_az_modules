resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku           # Premium 
  admin_enabled       = var.admin_enabled # false
  tags                = var.tags
  dynamic "georeplications" {
    for_each = var.is_georeplications_required == true ? [
      for s in var.georeplications_settings : {
        location                = s.location
        zone_redundancy_enabled = s.zone_redundancy_enabled
        tags                    = s.tags
    }] : []

    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
      tags                    = georeplications.value.tags
    }
  }
}