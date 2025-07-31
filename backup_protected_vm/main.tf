resource "azurerm_backup_protected_vm" "bkp_vm" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = var.source_vm_id
  backup_policy_id    = var.backup_policy_id
  exclude_disk_luns   = var.exclude_disk_luns
  include_disk_luns   = var.include_disk_luns
  protection_state    = var.protection_state
}