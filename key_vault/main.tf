resource "azurerm_key_vault" "kv" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption #false
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  tenant_id                       = var.tenant_id
  purge_protection_enabled        = var.purge_protection_enabled #false
  public_network_access_enabled   = var.public_network_access_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  sku_name                        = var.sku_name # "standard"
  tags                            = var.tags

  dynamic "network_acls" {
    for_each = var.is_network_acls_req == true ? [1] : []
    content {
      bypass                     = var.network_acls_bypass
      default_action             = var.network_acls_default_action
      virtual_network_subnet_ids = var.virtual_network_subnet_ids
      ip_rules                   = var.ip_rules
    }
  }

}

