resource "azurerm_network_interface" "nic" {
  for_each = {
    for item in flatten([
      for vm_key, vm_config in var.virtual_machines : [
        for index, nic in vm_config.network_interfaces : {
          key       = "${vm_key}-${index}"
          vm_key    = vm_key
          vm_config = vm_config
          nic       = nic
        }
      ]
    ]) :
    item.key => {
      vm_key            = item.vm_key
      vm_config         = item.vm_config
      network_interface = item.nic
    }
  }
  internal_dns_name_label        = each.value.network_interface.internal_dns_name_label
  ip_forwarding_enabled          = each.value.network_interface.ip_forwarding_enabled
  accelerated_networking_enabled = each.value.network_interface.accelerated_networking_enabled
  name                           = each.value.network_interface.name
  location                       = var.virtual_machines[each.value.vm_key].location
  resource_group_name            = try(each.value.network_interface.resource_group_name, var.virtual_machines[each.value.vm_key].resource_group_name)
  tags                           = var.virtual_machines[each.value.vm_key].tags
  dynamic "ip_configuration" {
    for_each = each.value.network_interface.ip_configuration
    content {
      name                                               = ip_configuration.value.name
      subnet_id                                          = try(ip_configuration.value.subnet_id, null)
      private_ip_address_allocation                      = ip_configuration.value.private_ip_allocation_method
      primary                                            = try(ip_configuration.value.primary, null)
      gateway_load_balancer_frontend_ip_configuration_id = try(ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id, null)
      public_ip_address_id                               = try(ip_configuration.value.public_ip_address_id, null)
      private_ip_address                                 = try(ip_configuration.value.private_ip_address, null)
    }
  }
}

resource "azurerm_managed_disk" "disk" {
  for_each = {
    for item in flatten([
      for vm_key, vm_config in var.virtual_machines :
      vm_config != null && try(length(vm_config.data_disks), 0) > 0 ? [
        for disk in lookup(vm_config, "data_disks", []) : {
          key                  = "${vm_key}-${disk.name}"
          name                 = disk.name
          storage_account_type = disk.storage_account_type
          disk_size_gb         = disk.disk_size_gb
          create_option        = disk.create_option
          vm_location          = vm_config.location
          vm_resource_group    = vm_config.resource_group_name
          tags                 = try(disk.tags, vm_config.tags, null)
        }
      ] : []
    ]) :
    item.key => item
  }

  name                 = each.value.name
  location             = each.value.vm_location
  resource_group_name  = each.value.vm_resource_group
  storage_account_type = each.value.storage_account_type
  disk_size_gb         = each.value.disk_size_gb
  create_option        = each.value.create_option
  tags                 = each.value.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_att" {
  depends_on = [azurerm_managed_disk.disk, azurerm_windows_virtual_machine.win_vm, azurerm_linux_virtual_machine.lin_vm]
  for_each = {
    for item in flatten([
      for vm_key, vm_config in var.virtual_machines :
      vm_config != null && try(length(vm_config.data_disks), 0) > 0 ? [
        for disk in lookup(vm_config, "data_disks", []) : {
          key     = "${vm_key}-${disk.name}"
          name    = disk.name
          lun     = disk.lun
          caching = disk.caching
          vm_id   = vm_config.os_type == "Windows" ? azurerm_windows_virtual_machine.win_vm[vm_key].id : azurerm_linux_virtual_machine.lin_vm[vm_key].id
        }
      ] : []
    ]) :
    item.key => item
  }

  managed_disk_id    = azurerm_managed_disk.disk[each.key].id
  virtual_machine_id = each.value.vm_id
  lun                = each.value.lun
  caching            = each.value.caching
}




resource "azurerm_windows_virtual_machine" "win_vm" {
  # depends_on = [azurerm_network_interface.nic, azurerm_managed_disk.disk]
  for_each   = { for vm_key, vm_config in var.virtual_machines : vm_key => vm_config if vm_config.os_type == "Windows" }

  name                  = each.value.name
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  size                  = each.value.vm_size
  admin_username        = each.value.admin_username
  admin_password        = try(each.value.admin_password, null)
  network_interface_ids = [for index, nic in each.value.network_interfaces : azurerm_network_interface.nic["${each.key}-${index}"].id]

  os_disk {
    caching                   = each.value.os_disk.caching
    storage_account_type      = each.value.os_disk.storage_account_type
    name                      = each.value.os_disk.name
    disk_size_gb              = each.value.os_disk.disk_size_gb
    write_accelerator_enabled = try(each.value.os_disk.write_accelerator_enabled, null)
  }

  source_image_reference {
    publisher = each.value.image.publisher
    offer     = each.value.image.offer
    sku       = each.value.image.sku
    version   = each.value.image.version
  }

  dynamic "boot_diagnostics" {
    for_each = each.value.boot_diagnostics != null ? [each.value.boot_diagnostics] : []
    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type = identity.value.type
    }
  }

  availability_set_id                                    = try(each.value.availability_set_id, null)
  custom_data                                            = try(each.value.custom_data, null)
  user_data                                              = try(each.value.user_data, null)
  edge_zone                                              = try(each.value.edge_zone, null)
  patch_mode                                             = try(each.value.patch_mode, null)
  priority                                               = try(each.value.priority, null)
  zone                                                   = try(each.value.zone, null)
  patch_assessment_mode                                  = try(each.value.patch_assessment_mode, null)
  computer_name                                          = try(each.value.computer_name, null)
  provision_vm_agent                                     = try(each.value.provision_vm_agent, null)
  enable_automatic_updates                               = try(each.value.enable_automatic_updates, null)
  encryption_at_host_enabled                             = try(each.value.encryption_at_host_enabled, null)
  hotpatching_enabled                                    = try(each.value.hotpatching_enabled, null)
  source_image_id                                        = try(each.value.source_image_id, null)
  bypass_platform_safety_checks_on_user_schedule_enabled = try(each.value.bypass_platform_safety_checks_on_user_schedule_enabled, null)
  vm_agent_platform_updates_enabled                      = try(each.value.vm_agent_platform_updates_enabled, null)
  vtpm_enabled                                           = try(each.value.vtpm_enabled, null)
  timezone                                               = try(each.value.timezone, null)

  dynamic "plan" {
    for_each = each.value.plan != null ? [each.value.plan] : []
    content {
      name      = plan.value.name
      publisher = plan.value.publisher
      product   = plan.value.product
    }
  }
  lifecycle {
    ignore_changes = [identity, tags]
  }

  tags = each.value.tags
}

resource "azurerm_linux_virtual_machine" "lin_vm" {
  # depends_on = [azurerm_network_interface.nic, azurerm_managed_disk.disk]
  for_each   = { for vm_key, vm_config in var.virtual_machines : vm_key => vm_config if vm_config.os_type == "Linux" }

  name                  = each.value.name
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  size                  = each.value.vm_size
  admin_username        = each.value.admin_username
  admin_password        = try(each.value.admin_password, null)
  network_interface_ids = [for index, nic in each.value.network_interfaces : azurerm_network_interface.nic["${each.key}-${index}"].id]

  os_disk {
    caching                   = each.value.os_disk.caching
    storage_account_type      = each.value.os_disk.storage_account_type
    name                      = each.value.os_disk.name
    disk_size_gb              = each.value.os_disk.disk_size_gb
    write_accelerator_enabled = try(each.value.os_disk.write_accelerator_enabled, null)
  }

  source_image_reference {
    publisher = each.value.image.publisher
    offer     = each.value.image.offer
    sku       = each.value.image.sku
    version   = each.value.image.version
  }

  dynamic "boot_diagnostics" {
    for_each = each.value.boot_diagnostics != null ? [each.value.boot_diagnostics] : []
    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type = identity.value.type
    }
  }

  dynamic "admin_ssh_key" {
    for_each = each.value.admin_ssh_key != null ? [each.value.admin_ssh_key] : []
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key != null ? admin_ssh_key.value.public_key : var.ssh_pub_key
    }
  }

  dynamic "plan" {
    for_each = each.value.plan != null ? [each.value.plan] : []
    content {
      name      = plan.value.name
      publisher = plan.value.publisher
      product   = plan.value.product
    }
  }

  disable_password_authentication                        = each.value.disable_password_authentication
  availability_set_id                                    = try(each.value.availability_set_id, null)
  custom_data                                            = try(each.value.custom_data, null)
  user_data                                              = try(each.value.user_data, null)
  edge_zone                                              = try(each.value.edge_zone, null)
  patch_mode                                             = try(each.value.patch_mode, null)
  priority                                               = try(each.value.priority, null)
  zone                                                   = try(each.value.zone, null)
  patch_assessment_mode                                  = try(each.value.patch_assessment_mode, null)
  computer_name                                          = try(each.value.computer_name, null)
  provision_vm_agent                                     = try(each.value.provision_vm_agent, null)
  encryption_at_host_enabled                             = try(each.value.encryption_at_host_enabled, null)
  bypass_platform_safety_checks_on_user_schedule_enabled = try(each.value.bypass_platform_safety_checks_on_user_schedule_enabled, null)
  source_image_id                                        = try(each.value.source_image_id, null)
  vm_agent_platform_updates_enabled                      = try(each.value.vm_agent_platform_updates_enabled, null)
  vtpm_enabled                                           = try(each.value.vtpm_enabled, null)

  lifecycle {
    ignore_changes = [identity, tags]
  }

  tags = each.value.tags
}

resource "azurerm_virtual_machine_extension" "ext" {
  depends_on = [azurerm_windows_virtual_machine.win_vm, azurerm_linux_virtual_machine.lin_vm, azurerm_virtual_machine_data_disk_attachment.disk_att]
  for_each = tomap({
    for vm_key, vm_config in var.virtual_machines :
    vm_key => {
      extensions = try(vm_config.extensions, null)
      os_type    = vm_config.os_type
    } if vm_config != null && try(vm_config.extensions, null) != null
  })

  name                 = each.value.extensions.name
  virtual_machine_id   = each.value.os_type == "Windows" ? azurerm_windows_virtual_machine.win_vm[each.key].id : azurerm_linux_virtual_machine.lin_vm[each.key].id
  publisher            = each.value.extensions.publisher
  type                 = each.value.extensions.type
  type_handler_version = each.value.extensions.type_handler_version
  settings             = each.value.extensions.settings
}



