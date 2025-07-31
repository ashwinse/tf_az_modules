resource "azurerm_express_route_circuit" "circuit" {

  name                  = var.configurations.name
  resource_group_name   = try(var.configurations.resource_group_name, var.resource_group_name)
  location              = try(var.configurations.location, var.location)
  tags                  = try(var.configurations.tags, var.tags)
  service_provider_name = try(var.configurations.service_provider_name, null)
  peering_location      = try(var.configurations.peering_location, null)
  bandwidth_in_mbps     = try(var.configurations.bandwidth_in_mbps, null)
  express_route_port_id = try(var.configurations.express_route_port_id, null)
  bandwidth_in_gbps     = try(var.configurations.bandwidth_in_gbps, null)

  sku {
    tier   = var.configurations.sku.tier
    family = var.configurations.sku.family
  }
}