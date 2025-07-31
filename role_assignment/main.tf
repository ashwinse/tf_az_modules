resource "azurerm_role_assignment" "role_assignment" {
  name                 = var.name
  scope                = var.scope
  principal_id         = var.principal_id
  role_definition_id   = var.role_definition_id
  role_definition_name = var.role_definition_name
}