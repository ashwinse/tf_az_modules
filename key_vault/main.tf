resource "azurerm_key_vault" "keyvault" {

  name                            = var.configurations.name
  resource_group_name             = try(var.configurations.resource_group_name, var.resource_group_name)
  location                        = try(var.configurations.location, var.location)
  tenant_id                       = var.configurations.tenant_id
  sku_name                        = try(var.configurations.sku_name, "standard")
  tags                            = try(var.configurations.tags, var.tags)
  enabled_for_deployment          = try(var.configurations.enabled_for_deployment, false)
  enabled_for_disk_encryption     = try(var.configurations.enabled_for_disk_encryption, false)
  enabled_for_template_deployment = try(var.configurations.enabled_for_template_deployment, false)
  purge_protection_enabled        = try(var.configurations.purge_protection_enabled, false)
  soft_delete_retention_days      = try(var.configurations.soft_delete_retention_days, 7)
  enable_rbac_authorization       = try(var.configurations.enable_rbac_authorization, false)
  public_network_access_enabled   = try(var.configurations.public_network_access_enabled, null)

  dynamic "network_acls" {
    for_each = lookup(var.configurations, "network_acls", null) == null ? [] : [1]

    content {
      bypass         = var.configurations.network_acls.bypass
      default_action = try(var.configurations.network_acls.default_action, "Deny")
      ip_rules       = try(var.configurations.network_acls.ip_rules, null)
      # virtual_network_subnet_ids = try(var.configurations.network.subnets, null) == null ? null : [
      #   for key, value in var.configurations.network.subnets : can(value.subnet_id) ? value.subnet_id : var.vnets[try(value.lz_key, var.client_config.landingzone_key)][value.vnet_key].subnets[value.subnet_key].id
      # ]
      virtual_network_subnet_ids = try(var.configurations.network_acls.virtual_network_subnet_ids, null)
    }
  }

  dynamic "contact" {
    for_each = lookup(var.configurations, "contacts", {})

    content {
      email = contact.value.email
      name  = try(contact.value.name, null)
      phone = try(contact.value.phone, null)
    }
  }

  lifecycle {
    ignore_changes = [
      resource_group_name, location
    ]
  }
}
