resource "azurerm_cdn_frontdoor_firewall_policy" "firewall_policy" {
  name                              = var.configurations.name
  resource_group_name               = try(var.configurations.resource_group_name, var.resource_group_name)
  sku_name                          = var.configurations.sku_name # "Premium_AzureFrontDoor"
  enabled                           = var.configurations.enabled
  mode                              = var.configurations.mode # "Detection"
  custom_block_response_status_code = var.configurations.custom_block_response_status_code
  tags                              = try(var.configurations.tags, var.tags, {})
  dynamic "custom_rule" {
    for_each = try(var.configurations.custom_rule, {})
    content {
      name     = custom_rule.value.name
      action   = custom_rule.value.action
      enabled  = try(custom_rule.value.enabled, null)
      priority = try(custom_rule.value.priority, null)
      type     = custom_rule.value.type
      dynamic "match_condition" {
        for_each = try(custom_rule.value.match_condition, {})
        content {
          match_variable     = match_condition.value.match_variable
          match_values       = match_condition.value.match_values
          operator           = match_condition.value.operator
          selector           = try(match_condition.value.selector, null)
          negation_condition = try(match_condition.value.negation_condition, null)
          transforms         = try(match_condition.value.transforms, null)
        }
      }

    }
  }
  dynamic "managed_rule" {
    for_each = try(var.configurations.managed_rule, {})
    content {
      type    = managed_rule.value.type
      version = managed_rule.value.version
      action  = managed_rule.value.action
      dynamic "exclusion" {
        for_each = try(managed_rule.value.exclusion, {})
        content {
          match_variable = exclusion.value.match_variable
          operator       = exclusion.value.operator
          selector       = exclusion.value.selector
        }
      }
      dynamic "override" {
        for_each = try(managed_rule.value.override, {})
        content {
          rule_group_name = override.value.rule_group_name
          dynamic "exclusion" {
            for_each = try(override.value.exclusion, {})
            content {
              match_variable = exclusion.value.match_variable
              operator       = exclusion.value.operator
              selector       = exclusion.value.selector
            }
          }
          dynamic "rule" {
            for_each = try(override.value.rule, {})
            content {
              rule_id = rule.value.rule_id
              action  = rule.value.action
              enabled = rule.value.enabled
              dynamic "exclusion" {
                for_each = try(override.value.exclusion, {})
                content {
                  match_variable = exclusion.value.match_variable
                  operator       = exclusion.value.operator
                  selector       = exclusion.value.selector
                }
              }
            }
          }
        }
      }
    }
  }
}