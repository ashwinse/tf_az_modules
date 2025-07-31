module "keyvault" {
  source                          = "./key_vault"
  for_each                        = var.key_vaults
  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  enable_rbac_authorization       = each.value.enable_rbac_authorization
  tenant_id                       = data.azuread_client_config.current.tenant_id
  purge_protection_enabled        = each.value.purge_protection_enabled
  public_network_access_enabled   = each.value.public_network_access_enabled
  soft_delete_retention_days      = each.value.soft_delete_retention_days
  tags                            = each.value.tags
  sku_name                        = each.value.sku_name
}

module "keyvault_accesspolicy" {
  source                  = "./key_vault_access_policies"
  for_each                = var.key_vault_access_policies
  key_vault_id            = merge(module.keyvault.*...)[each.value.key_vault_key]["id"]
  tenant_id               = data.azuread_client_config.current.tenant_id
  object_id               = data.azuread_client_config.current.object_id
  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  certificate_permissions = each.value.certificate_permissions
}
