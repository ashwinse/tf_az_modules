resource "azurerm_log_analytics_workspace" "law" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku               # "PerGB2018"
  retention_in_days   = var.retention_in_days # 30
  tags                = var.tags
}