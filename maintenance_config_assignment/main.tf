resource "azurerm_maintenance_assignment_virtual_machine" "mc_vm_assign" {
  location                     = try(var.configurations.location, var.location)
  maintenance_configuration_id = try(var.maintenance_config[var.configurations.maintenance_config_key].id, var.configurations.maintenance_config_id)
  virtual_machine_id           = try(var.virtual_machines[var.configurations.virtual_machine_key].virtual_machine_ids[0], var.configurations.virtual_machine_id)
}
