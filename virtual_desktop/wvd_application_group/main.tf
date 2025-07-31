resource "azurerm_virtual_desktop_application_group" "dag" {
  name                         = var.name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  type                         = var.type
  host_pool_id                 = var.host_pool_id
  tags                         = var.tags
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspaceremoteapp" {
  workspace_id         = var.workspace_id
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
}
