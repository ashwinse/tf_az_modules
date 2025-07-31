resource "azurerm_web_application_firewall_policy" "waf_policy" {
  name                = var.configurations.name
  resource_group_name = try(var.configurations.resource_group_name, var.resource_group_name)
  location            = try(var.configurations.location, var.location)

  dynamic "custom_rules" {
    for_each = var.configurations.custom_rules != null ? var.configurations.custom_rules : {}
    content {
      name      = try(custom_rules.value.name, null)
      enabled   = try(custom_rules.value.enabled, true)
      priority  = custom_rules.value.priority
      rule_type = custom_rules.value.rule_type

      dynamic "match_conditions" {
        for_each = custom_rules.value.match_conditions
        content {
          dynamic "match_variables" {
            for_each = match_conditions.value.match_variables
            content {
              variable_name = match_variables.value.variable_name
            }
          }
          operator           = match_conditions.value.operator
          negation_condition = try(match_conditions.value.negation_condition, false)
          match_values       = try(match_conditions.value.match_values, [])
          transforms         = try(match_conditions.value.transforms, [])
        }
      }
      action               = custom_rules.value.action
      rate_limit_duration  = try(custom_rules.value.rate_limit_duration, null)
      rate_limit_threshold = try(custom_rules.value.rate_limit_threshold, null)
      group_rate_limit_by  = try(custom_rules.value.group_rate_limit_by, null)
    }
  }

  dynamic "managed_rules" {
    for_each = var.configurations.managed_rules
    content {
      dynamic "exclusion" {
        for_each = try(managed_rules.value.exclusion, {})
        content {
          match_variable          = exclusion.value.match_variable
          selector                = exclusion.value.selector
          selector_match_operator = exclusion.value.selector_match_operator
          dynamic "excluded_rule_set" {
            for_each = try(exclusion.value.excluded_rule_set, {})
            content {
              type    = excluded_rule_set.value.type
              version = excluded_rule_set.value.version
              dynamic "rule_group" {
                for_each = try(excluded_rule_set.value.rule_group, {})
                content {
                  rule_group_name = rule_group.value.rule_group_name
                  excluded_rules  = try(rule_group.value.excluded_rules, [])
                }
              }
            }
          }
        }
      }
      dynamic "managed_rule_set" {
        for_each = managed_rules.value.managed_rule_set
        content {
          type    = try(managed_rule_set.value.type, null)
          version = managed_rule_set.value.version
          dynamic "rule_group_override" {
            for_each = try(managed_rule_set.value.rule_group_override, {})
            content {
              rule_group_name = rule_group_override.value.rule_group_name
              dynamic "rule" {
                for_each = try(rule_group_override.value.rule, {})
                content {
                  id      = rule.value.id
                  enabled = try(rule.value.enabled, null)
                  action  = try(rule.value.action, null)
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "policy_settings" {
    for_each = try(var.configurations.policy_settings, {}) != {} ? [1] : []
    content {
      enabled                          = try(var.configurations.policy_settings.enabled, null)
      mode                             = try(var.configurations.policy_settings.mode, null)
      file_upload_limit_in_mb          = try(var.configurations.policy_settings.file_upload_limit_in_mb, null)
      request_body_check               = try(var.configurations.policy_settings.request_body_check, null)
      max_request_body_size_in_kb      = try(var.configurations.policy_settings.max_request_body_size_in_kb, null)
      request_body_inspect_limit_in_kb = try(var.configurations.policy_settings.request_body_inspect_limit_in_kb, null)
    }
  }
  tags = try(var.configurations.tags, var.tags, {})

}