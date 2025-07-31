resource "azurerm_resource_group_template_deployment" "example" {
  name                = var.name
  resource_group_name = var.resource_group_name
  deployment_mode     = var.deployment_mode
  parameters_content  = file(var.parameters_content)
  template_content    = file(var.template_content)
}