resource "azurerm_firewall_policy" "fw_policy" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  auto_learn_private_ranges_enabled = var.auto_learn_private_ranges_enabled
  sku                               = var.sku
  tags                              = var.tags
  intrusion_detection {
    mode = var.intrusion_detection_mode
  }

  dynamic "dns" {
    for_each = var.dns != null ? var.dns : {}
    content {
      proxy_enabled = lookup(dns.value, "proxy_enabled", "false")
      servers       = lookup(dns.value, "servers", [])
    }
  }

  insights {
    default_log_analytics_workspace_id = var.insights.default_log_analytics_workspace_id
    enabled                            = var.insights.enabled
    retention_in_days                  = var.insights.retention_in_days
    dynamic "log_analytics_workspace" {
      for_each = try(var.insights.log_analytics_workspace, {}) != {} ? [1] : []
      content {
        id                = var.insights.log_analytics_workspace.id
        firewall_location = var.insights.log_analytics_workspace.firewall_location
      }
    }
  }
}