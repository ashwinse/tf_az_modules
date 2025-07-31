resource "azurerm_monitor_scheduled_query_rules_alert_v2" "sqra" {
  name                = var.configurations.name
  resource_group_name = try(var.configurations.resource_group_name, var.resource_group_name)
  location            = try(var.configurations.location, var.location)

  dynamic "criteria" {
    for_each = try(var.configurations.criteria, null) != null ? [var.configurations.criteria] : []
    content {
      operator                = try(criteria.value.operator, null)
      query                   = try(criteria.value.query, null)
      threshold               = try(criteria.value.threshold, null)
      time_aggregation_method = try(criteria.value.time_aggregation_method, null)
      dynamic "dimension" {
        for_each = try(var.configurations.dimension, null) != null ? [var.configurations.dimension] : []
        content {
          name     = try(dimension.value.name, null)
          operator = try(dimension.value.operator, null)
          values   = try(dimension.value.values, null)
        }
      }
      dynamic "failing_periods" {
        for_each = try(criteria.value.failing_periods, null) != null ? [criteria.value.failing_periods] : []
        content {
          minimum_failing_periods_to_trigger_alert = try(criteria.value.failing_periods.minimum_failing_periods_to_trigger_alert, null)
          number_of_evaluation_periods             = try(criteria.value.failing_periods.number_of_evaluation_periods, null)
        }
      }
      metric_measure_column = try(var.configurations.metric_measure_column, null)
      resource_id_column    = try(var.configurations.resource_id_column, null)
    }
  }

  evaluation_frequency = try(var.configurations.evaluation_frequency, null)
  scopes               = var.configurations.scopes
  severity             = var.configurations.severity
  window_duration      = var.configurations.window_duration

  dynamic "action" {
    for_each = try(var.configurations.action, null) != null ? [var.configurations.action] : []
    content {
      action_groups     = coalesce([try(var.action_group_id[action.value.action_group.key].id, null)], try(action.value.action_group.ids, null), null)
      custom_properties = try(action.value.custom_properties, null)
    }
  }

  auto_mitigation_enabled           = try(var.configurations.auto_mitigation_enabled, null)
  workspace_alerts_storage_enabled  = try(var.configurations.workspace_alerts_storage_enabled, null)
  description                       = try(var.configurations.description, null)
  display_name                      = try(var.configurations.display_name, null)
  enabled                           = try(var.configurations.enabled, null)
  mute_actions_after_alert_duration = try(var.configurations.mute_actions_after_alert_duration, null)
  query_time_range_override         = try(var.configurations.query_time_range_override, null)
  skip_query_validation             = try(var.configurations.skip_query_validation, null)
  tags                              = try(var.configurations.tags, var.tags)
  target_resource_types             = try(var.configurations.target_resource_types, null)
  # dynamic "identity" {
  #   for_each = try(var.configurations.identity, null) != null ? [var.configurations.identity] : []
  #   content {
  #     type         = identity.value.type
  #     identity_ids = try(identity.value.identity_ids, null)
  #   }
  # }
}