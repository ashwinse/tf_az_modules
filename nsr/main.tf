resource "azurerm_network_security_rule" "nsr" {
  name                         = var.name
  priority                     = var.priority
  direction                    = var.direction
  access                       = var.access
  protocol                     = var.protocol
  source_port_range            = var.source_port_ranges == null ? var.source_port_range : null
  source_port_ranges           = var.source_port_range == null ? var.source_port_ranges : null
  destination_port_range       = var.destination_port_ranges == null ? var.destination_port_range : null
  destination_port_ranges      = var.destination_port_range == null ? var.destination_port_ranges : null
  source_address_prefix        = var.source_address_prefixes == null ? var.source_address_prefix : null
  source_address_prefixes      = var.source_address_prefix == null ? var.source_address_prefixes : null
  destination_address_prefix   = var.destination_address_prefixes == null ? var.destination_address_prefix : null
  destination_address_prefixes = var.destination_address_prefix == null ? var.destination_address_prefixes : null
  resource_group_name          = var.resource_group_name
  network_security_group_name  = var.network_security_group_name
}