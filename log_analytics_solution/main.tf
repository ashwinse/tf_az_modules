resource "azurerm_log_analytics_solution" "las" {
  solution_name         = var.solution_name //"ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = var.workspace_resource_id
  workspace_name        = var.workspace_name

  plan {
    publisher = var.plan_publisher // "Microsoft"
    product   = var.plan_product   // "OMSGallery/ContainerInsights"
  }
}