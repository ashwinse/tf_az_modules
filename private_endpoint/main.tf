resource "azurerm_private_endpoint" "pe" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.subnet_id
  custom_network_interface_name = var.custom_network_interface_name

  private_service_connection {
    name                           = var.name
    private_connection_resource_id = try(var.private_connection_resource_id, null)
    is_manual_connection           = var.is_manual_connection
    subresource_names              = try(var.subresource_names, null)
    request_message                = try(var.request_message, null)
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_group != null ? var.private_dns_zone_group : {}

    content {
      name = lookup(private_dns_zone_group.value, "zone_group_name", "default")
      # private_dns_zone_ids = local.private_dns_zone_ids
      private_dns_zone_ids = private_dns_zone_group.value.private_dns_zone_ids
    }
  }

  dynamic "ip_configuration" {
    for_each = var.ip_configurations != null ? var.ip_configurations : {}

    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      subresource_name   = lookup(ip_configuration.value, "subresource_name", null)
      member_name        = lookup(ip_configuration.value, "member_name", null)
    }
  }
  tags = var.tags
}