
resource "azurerm_key_vault_secret" "client_id" {
  name         = format("%s-client-id", var.secret_prefix)
  value        = var.service_principal_application_id
  key_vault_id = var.keyvault_name
}

resource "azurerm_key_vault_secret" "client_secret" {
  name            = format("%s-client-secret", var.secret_prefix)
  value           = azuread_service_principal_password.pwd.value
  key_vault_id = var.keyvault_name
  expiration_date = timeadd(time_rotating.pwd.id, format("%sh", local.password_policy.expire_in_days * 24))
}

resource "azurerm_key_vault_secret" "tenant_id" {
  name         = format("%s-tenant-id", var.secret_prefix)
  value        = var.client_config.tenant_id
  key_vault_id = var.keyvault_name
}
