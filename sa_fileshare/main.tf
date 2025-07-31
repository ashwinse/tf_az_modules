resource "azurerm_storage_share" "fs" {
  name                 = var.name
  storage_account_name = var.storage_account_name
  quota                = var.quota
}