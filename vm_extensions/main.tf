resource "azurerm_virtual_machine_extension" "vmext" {
  name                       = var.name
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = var.publisher
  type                       = var.type
  type_handler_version       = var.type_handler_version
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = var.automatic_upgrade_enabled
  tags                       = var.tags
  lifecycle {
    ignore_changes = [tags]
  }
}