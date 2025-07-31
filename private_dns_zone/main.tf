
resource "azurerm_private_dns_zone" "private_dns" {
  name                = var.configurations.name
  resource_group_name = try(var.configurations.resource_group_name, var.resource_group_name)
  tags                = try(var.configurations.tags, var.tags)
}


resource "azurerm_private_dns_a_record" "a_records" {
  for_each = try(var.configurations.records.a_records, {})

  name                = each.value.name
  resource_group_name = try(var.configurations.resource_group_name, var.resource_group_name)
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  tags                = merge(try(var.configurations.tags, var.tags), try(each.value.tags, {}))
  records             = each.value.records
}

resource "azurerm_private_dns_aaaa_record" "aaaa_records" {
  for_each = try(var.configurations.records.aaaa_records, {})

  name                = each.value.name
  resource_group_name = try(var.configurations.resource_group_name, var.resource_group_name)
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  tags                = merge(try(var.configurations.tags, var.tags), try(each.value.tags, {}))
  records             = each.value.records
}

resource "azurerm_private_dns_cname_record" "cname_records" {
  for_each = try(var.configurations.records.cname_records, {})

  name                = each.value.name
  resource_group_name = try(var.configurations.resource_group_name, var.resource_group_name)
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  tags                = merge(try(var.configurations.tags, var.tags), try(each.value.tags, {}))
  record              = each.value.records
}

resource "azurerm_private_dns_mx_record" "mx_records" {
  for_each = try(var.configurations.records.mx_records, {})

  name                = each.value.name
  resource_group_name = try(var.configurations.resource_group_name, var.resource_group_name)
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  tags                = merge(try(var.configurations.tags, var.tags), try(each.value.tags, {}))

  dynamic "record" {
    for_each = each.value.records

    content {
      preference = record.value.preference
      exchange   = record.value.exchange
    }
  }
}

resource "azurerm_private_dns_ptr_record" "ptr_records" {
  for_each = try(var.configurations.records.ptr_records, {})

  name                = each.value.name
  resource_group_name = try(var.configurations.resource_group_name, var.resource_group_name)
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  tags                = merge(try(var.configurations.tags, var.tags), try(each.value.tags, {}))
  records             = each.value.records
}

resource "azurerm_private_dns_srv_record" "srv_records" {
  for_each = try(var.configurations.records.srv_records, {})

  name                = each.value.name
  resource_group_name = try(var.configurations.resource_group_name, var.resource_group_name)
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  tags                = merge(try(var.configurations.tags, var.tags), try(each.value.tags, {}))

  dynamic "record" {
    for_each = each.value.records

    content {
      priority = record.value.priority
      weight   = record.value.weight
      port     = record.value.port
      target   = record.value.target
    }
  }
}

resource "azurerm_private_dns_txt_record" "txt_records" {
  for_each = try(var.configurations.records.txt_records, {})

  name                = each.value.name
  resource_group_name = try(var.configurations.resource_group_name, var.resource_group_name)
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  tags                = merge(try(var.configurations.tags, var.tags), try(each.value.tags, {}))

  dynamic "record" {
    for_each = each.value.records

    content {
      value = record.value.value
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_links" {
  for_each              = try(var.configurations.vnet_links, {})
  name                  = each.value.name
  resource_group_name   = try(var.configurations.resource_group_name, var.resource_group_name)
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = each.value.virtual_network_id
  registration_enabled  = try(each.value.registration_enabled, false)
  tags                  = merge(try(var.configurations.tags, var.tags), try(each.value.tags, {}))
}