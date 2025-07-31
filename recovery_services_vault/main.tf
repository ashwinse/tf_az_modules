resource "azurerm_recovery_services_vault" "rsv" {
  name                          = var.configurations.name
  resource_group_name           = try(var.configurations.resource_group_name, var.resource_group_name)
  location                      = try(var.configurations.location, var.location)
  sku                           = var.configurations.sku
  tags                          = try(var.configurations.tags, var.tags)
  soft_delete_enabled           = try(var.configurations.soft_delete_enabled, true)
  storage_mode_type             = try(var.configurations.storage_mode_type, null)
  public_network_access_enabled = try(var.configurations.public_network_access_enabled, null)
  immutability                  = try(var.configurations.immutability, null)
  cross_region_restore_enabled  = try(var.configurations.cross_region_restore_enabled, null)
  classic_vmware_replication_enabled = try(var.configurations.classic_vmware_replication_enabled, null)

  dynamic "identity" {
    for_each = try(var.configurations.identity, null) == null ? [] : [1]
    content {
      type         = var.configurations.identity.type
      identity_ids = var.configurations.identity.identity_ids
    }
  }

  dynamic "encryption" {
    for_each = try(var.configurations.encryption, null) == null ? [] : [1]
    content {
      key_id         = var.configurations.encryption.type
      infrastructure_encryption_enabled = var.configurations.encryption.encryption.infrastructure_encryption_enabled
      user_assigned_identity_id = try(var.configurations.encryption.user_assigned_identity_id, null)
      use_system_assigned_identity = try(var.configurations.encryption.use_system_assigned_identity, null)
    }
  }

  dynamic "monitoring" {
    for_each = try(var.configurations.monitoring, null) == null ? [] : [1]
    content {
      alerts_for_all_job_failures_enabled = try(var.configurations.monitoring.alerts_for_all_job_failures_enabled, null)
      alerts_for_critical_operation_failures_enabled = try(var.configurations.monitoring.alerts_for_critical_operation_failures_enabled, null)
    }
  } 

}