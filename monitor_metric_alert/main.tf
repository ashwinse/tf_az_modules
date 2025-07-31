resource "azurerm_monitor_metric_alert" "mma" {
  name                = var.configurations.name
  resource_group_name = try(var.configurations.resource_group_name, var.resource_group_name)
  # scopes = try(flatten([
  #   for key, value in var.configurations.scopes : coalesce(try(value.id, null), [])
  # ]), [])
  scopes = var.configurations.scopes
  dynamic "criteria" {
    for_each = try(var.configurations.criteria, null) != null ? [var.configurations.criteria] : []
    content {
      metric_namespace = try(criteria.value.metric_namespace, null)
      metric_name      = try(criteria.value.metric_name, null)
      aggregation      = try(criteria.value.aggregation, null)
      operator         = try(criteria.value.operator, null)
      threshold        = try(criteria.value.threshold, null)
      dynamic "dimension" {
        for_each = try(var.configurations.dimension, null) != null ? [var.configurations.dimension] : []
        content {
          name     = try(dimension.value.name, null)
          operator = try(dimension.value.operator, null)
          values   = try(dimension.value.values, null)
        }
      }
      skip_metric_validation = try(criteria.value.skip_metric_validation, null)
    }
  }
  dynamic "dynamic_criteria" {
    for_each = try(var.configurations.dynamic_criteria, null) != null ? [var.configurations.dynamic_criteria] : []
    content {
      metric_namespace  = try(dynamic_criteria.value.metric_namespace, null)
      metric_name       = try(dynamic_criteria.value.metric_name, null)
      aggregation       = try(dynamic_criteria.value.aggregation, null)
      operator          = try(dynamic_criteria.value.operator, null)
      alert_sensitivity = try(dynamic_criteria.value.alert_sensitivity, null)
      dynamic "dimension" {
        for_each = try(var.configurations.dimension, null) != null ? [var.configurations.dimension] : []
        content {
          name     = try(dimension.value.name, null)
          operator = try(dimension.value.operator, null)
          values   = try(dimension.value.values, null)
        }
      }
      evaluation_total_count   = try(dynamic_criteria.value.evaluation_total_count, null)
      evaluation_failure_count = try(dynamic_criteria.value.evaluation_failure_count, null)
      ignore_data_before       = try(dynamic_criteria.value.ignore_data_before, null)
      skip_metric_validation   = try(dynamic_criteria.value.skip_metric_validation, null)
    }
  }
  dynamic "application_insights_web_test_location_availability_criteria" {
    for_each = try(var.configurations.application_insights_web_test_location_availability_criteria, null) != null ? [var.configurations.application_insights_web_test_location_availability_criteria] : []
    content {
      web_test_id = try(
        application_insights_web_test_location_availability_criteria.value.web_test_id,
      )
      component_id = try(
        application_insights_web_test_location_availability_criteria.value.component_id,
      )
      failed_location_count = try(application_insights_web_test_location_availability_criteria.value.failed_location_count, null)
    }
  }
  dynamic "action" {
    for_each = try(var.configurations.action, null) != null ? [var.configurations.action] : []
    content {
      action_group_id = coalesce(
        try(var.action_group_id[action.value.action_group.key].id, null),
        try(action.value.action_group.id, null)
      )
      webhook_properties = try(action.value.webhook_properties, null)
    }
  }
  enabled                  = try(var.configurations.enabled, null)
  auto_mitigate            = try(var.configurations.auto_mitigate, null)
  description              = try(var.configurations.description, null)
  frequency                = try(var.configurations.frequency, null)
  severity                 = try(var.configurations.severity, null)
  target_resource_type     = try(var.configurations.target_resource_type, null)
  target_resource_location = try(var.configurations.target_resource_location, null)
  window_size              = try(var.configurations.window_size, null)
  tags                     = try(var.configurations.tags, var.tags)
}