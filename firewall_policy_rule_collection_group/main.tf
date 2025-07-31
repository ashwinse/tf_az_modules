resource "azurerm_firewall_policy_rule_collection_group" "fw_rule_coll" {
  name               = var.name
  firewall_policy_id = var.firewall_policy_id
  priority           = var.priority

  application_rule_collection {
    name     = var.application_rule_collection.name
    action   = var.application_rule_collection.action
    priority = var.application_rule_collection.priority
    dynamic "rule" {
      for_each = var.application_rule_collection.rule != null ? var.application_rule_collection.rule : {}
      content {
        name = rule.value.name
        dynamic "protocols" {
          for_each = rule.value.protocols
          content {
            type = protocols.value.type
            port = protocols.value.port
          }
        }
        source_addresses  = lookup(rule.value, "source_addresses", [])
        destination_fqdns = lookup(rule.value, "destination_fqdns", [])
      }
    }
  }

  network_rule_collection {
    name     = var.network_rule_collection.name
    action   = var.network_rule_collection.action
    priority = var.network_rule_collection.priority
    dynamic "rule" {
      for_each = var.network_rule_collection.rule
      content {
        name                  = rule.value.name
        protocols             = rule.value.protocols
        destination_ports     = rule.value.destination_ports
        source_addresses      = try(rule.value.source_addresses, null)
        destination_addresses = try(rule.value.destination_addresses, null)
        destination_fqdns     = try(rule.value.destination_fqdns, null)
      }
    }
  }

  nat_rule_collection {
    name     = var.nat_rule_collection.name
    action   = var.nat_rule_collection.action
    priority = var.nat_rule_collection.priority
    dynamic "rule" {
      for_each = try(var.nat_rule_collection.rule, {})
      content {
        name                = rule.value.name
        protocols           = rule.value.protocols
        destination_ports   = rule.value.destination_ports
        source_addresses    = lookup(rule.value, "source_addresses", [])
        destination_address = lookup(rule.value, "destination_address", null)
        translated_port     = rule.value.translated_port
        translated_address  = rule.value.translated_address
      }
    }
  }

}