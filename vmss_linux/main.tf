data "azurerm_subnet" "subnet" {
  for_each             = var.subnet_info
  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

resource "azurerm_linux_virtual_machine_scale_set" "vmssl" {
  depends_on          = [data.azurerm_subnet.subnet]
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  instances           = var.instances
  admin_password      = var.admin_password
  admin_username      = var.admin_username
  disable_password_authentication = var.disable_password_authentication
  dynamic "admin_ssh_key" {
    for_each = var.disable_password_authentication == true ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.public_key
    }
  }
  dynamic "automatic_instance_repair" {
    for_each = var.automatic_instance_repair_enabled == true ? [1] : []
    content {
      enabled      = var.automatic_instance_repair_enabled
      grace_period = var.automatic_instance_repair_grace_period
    }
  }


  dynamic "automatic_os_upgrade_policy" {
    for_each = (var.upgrade_mode == "Automatic" || var.upgrade_mode == "Rolling" && var.is_automatic_os_upgrade_policy == true) ? [1] : []
    content {
      disable_automatic_rollback  = var.disable_automatic_rollback
      enable_automatic_os_upgrade = var.enable_automatic_os_upgrade
    }
  }
  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_storage_account_uri != null ? [1] : []
    content {
      storage_account_uri = var.boot_diagnostics_storage_account_uri
    }
  }
  capacity_reservation_group_id = (var.proximity_placement_group_id == null && var.single_placement_group == false) ? var.capacity_reservation_group_id : null
  computer_name_prefix          = var.computer_name_prefix
  custom_data                   = var.custom_data

  dynamic "data_disk" {
    for_each = var.is_data_disk_required == true ? [
      for s in var.data_disk_settings : {
        # name                      = s.name
        caching                   = s.caching
        create_option             = s.create_option
        disk_size_gb              = s.disk_size_gb
        storage_account_type      = s.storage_account_type
        lun                       = s.lun
        disk_encryption_set_id    = s.disk_encryption_set_id
        write_accelerator_enabled = s.write_accelerator_enabled
    }] : []
    content {
      # name                      = data_disk.value.name
      caching                   = data_disk.value.caching
      create_option             = data_disk.value.create_option
      disk_size_gb              = data_disk.value.disk_size_gb
      storage_account_type      = data_disk.value.storage_account_type
      lun                       = data_disk.value.lun
      disk_encryption_set_id    = try(data_disk.value.disk_encryption_set_id, null)
      write_accelerator_enabled = try(data_disk.value.write_accelerator_enabled, null)
    }
  }
  edge_zone                  = var.edge_zone
  encryption_at_host_enabled = var.encryption_at_host_enabled
  eviction_policy            = var.eviction_policy # Deallocate and Delete
  dynamic "gallery_application" {
    for_each = var.is_gallery_application == true ? [1] : []
    content {
      version_id             = var.gallery_application_version_id
      configuration_blob_uri = var.gallery_application_configuration_blob_uri
      order                  = var.gallery_application_order
    }
  }
  health_probe_id = (var.upgrade_mode == "Automatic" || var.upgrade_mode == "Rolling") ? var.health_probe_id : null
  host_group_id   = var.host_group_id
  dynamic "identity" {
    for_each = var.is_identity == true ? [1] : []
    content {
      type         = var.identity_type # SystemAssigned, UserAssigned, SystemAssigned, UserAssigned
      identity_ids = var.identity_ids
    }

  }
  
  overprovision = var.overprovision
  dynamic "plan" {
    for_each = var.is_image_from_marketplace == true ? [1] : []
    content {
      name      = var.plan_name
      publisher = var.plan_publisher
      product   = var.plan_product
    }
  }


  platform_fault_domain_count  = var.platform_fault_domain_count
  priority                     = var.priority
  provision_vm_agent           = var.provision_vm_agent
  proximity_placement_group_id = var.proximity_placement_group_id
  dynamic "rolling_upgrade_policy" {
    for_each = var.is_rolling_upgrade_policy == true ? [1] : []
    content {
      max_batch_instance_percent              = var.max_batch_instance_percent
      max_unhealthy_instance_percent          = var.max_unhealthy_instance_percent
      max_unhealthy_upgraded_instance_percent = var.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = var.pause_time_between_batches
    }
  }
  dynamic "scale_in" {
    for_each = var.is_scale_in == true ? [1] : []
    content {
      rule                   = var.scale_in_rule # Default, NewestVM and OldestVM 
      force_deletion_enabled = var.scale_in_force_deletion_enabled
    }
  }
  secure_boot_enabled    = var.secure_boot_enabled
  single_placement_group = var.single_placement_group # true
  source_image_id        = var.source_image_id
  dynamic "source_image_reference" {
    for_each = var.source_image_id == null ? [1] : []
    content {
      publisher = var.content_publisher # "MicrosoftWindowsServer"
      offer     = var.content_offer     # "WindowsServer"
      sku       = var.content_sku       # "2016-Datacenter"
      version   = var.content_version   # "latest"
    }
  }
  dynamic "spot_restore" {
    for_each = var.spot_restore_enabled == true ? [1] : []
    content {
      enabled = var.spot_restore_enabled
      timeout = var.spot_restore_timeout
    }
  }
  dynamic "termination_notification" {
    for_each = var.termination_notification_enabled == true ? [1] : []
    content {
      enabled = var.termination_notification_enabled
      timeout = var.termination_notification_timeout
    }
  }
  upgrade_mode = var.upgrade_mode # Automatic, Manual and Rolling
  user_data    = var.user_data
  vtpm_enabled = var.vtpm_enabled
  zone_balance = var.zone_balance
  zones        = var.zones
  os_disk {
    caching                          = var.os_disk_caching      # "ReadWrite"
    storage_account_type             = var.storage_account_type # "Standard_LRS"
    disk_size_gb                     = var.disk_size_gb
    write_accelerator_enabled        = var.write_accelerator_enabled
    security_encryption_type         = var.security_encryption_type
    disk_encryption_set_id           = var.secure_vm_disk_encryption_set_id == null ? var.disk_encryption_set_id : null
    secure_vm_disk_encryption_set_id = var.security_encryption_type == "DiskWithVMGuestState" ? var.secure_vm_disk_encryption_set_id : null
  }
  network_interface {
    name                          = var.network_interface_name
    primary                       = true
    dns_servers                   = var.dns_servers
    enable_accelerated_networking = var.enable_accelerated_networking
    enable_ip_forwarding          = var.enable_ip_forwarding
    network_security_group_id     = var.network_security_group_id
    ip_configuration {
      name                                         = "internal"
      primary                                      = true
      subnet_id                                    = var.subnet_id
      application_gateway_backend_address_pool_ids = var.application_gateway_backend_address_pool_ids
      application_security_group_ids               = var.application_security_group_ids
      load_balancer_backend_address_pool_ids       = var.load_balancer_backend_address_pool_ids
      load_balancer_inbound_nat_rules_ids          = var.load_balancer_inbound_nat_rules_ids
      version                                      = var.ip_configuration_version
      dynamic "public_ip_address" {
        for_each = var.is_public_ip_address == true ? [1] : []
        content {
          name                    = var.public_ip_address_name
          domain_name_label       = var.public_ip_address_domain_name_label
          idle_timeout_in_minutes = var.public_ip_address_idle_timeout_in_minutes
        }
      }
    }
  }

  dynamic "network_interface" {
    for_each = var.is_additional_nic_required == true ? [
      for n in var.additional_nic_settings : {
        name                                         = n.name
        dns_servers                                  = n.dns_servers
        primary                                      = n.primary
        enable_accelerated_networking                = n.enable_accelerated_networking
        enable_ip_forwarding                         = n.enable_ip_forwarding
        network_security_group_id                    = n.network_security_group_id
        subnet_id                                    = n.subnet_id
        application_gateway_backend_address_pool_ids = n.application_gateway_backend_address_pool_ids
        application_security_group_ids               = n.application_security_group_ids
        load_balancer_backend_address_pool_ids       = n.load_balancer_backend_address_pool_ids
        load_balancer_inbound_nat_rules_ids          = n.load_balancer_inbound_nat_rules_ids
        ip_configuration_name                        = n.ip_configuration_name
        version                                      = n.version
        is_public_ip_address                         = n.is_public_ip_address
        public_ip_address_name                       = n.public_ip_address_name
        public_ip_address_domain_name_label          = n.public_ip_address_domain_name_label
        public_ip_address_idle_timeout_in_minutes    = n.public_ip_address_idle_timeout_in_minutes
      }
    ] : []
    content {
      name                          = network_interface.value.name
      primary                       = try(network_interface.value.primary, false)
      dns_servers                   = network_interface.value.dns_servers
      enable_accelerated_networking = network_interface.value.enable_accelerated_networking
      enable_ip_forwarding          = network_interface.value.enable_ip_forwarding
      network_security_group_id     = network_interface.value.network_security_group_id
      ip_configuration {
        name                                         = network_interface.value.ip_configuration_name
        primary                                      = try(network_interface.value.primary, false)
        subnet_id                                    = lookup(data.azurerm_subnet.subnet, network_interface.value.subnet_id).id
        application_gateway_backend_address_pool_ids = try(network_interface.value.application_gateway_backend_address_pool_ids, [null])
        application_security_group_ids               = try(network_interface.value.application_security_group_ids, [null])
        load_balancer_backend_address_pool_ids       = try(network_interface.value.load_balancer_backend_address_pool_ids, [null])
        load_balancer_inbound_nat_rules_ids          = try(network_interface.value.load_balancer_inbound_nat_rules_ids, [null])
        version                                      = try(network_interface.value.version, "IPv4")
        dynamic "public_ip_address" {
          for_each = network_interface.value.is_public_ip_address == true ? [1] : []
          content {
            name                    = network_interface.value.public_ip_address_name
            domain_name_label       = try(network_interface.value.public_ip_address_domain_name_label, null)
            idle_timeout_in_minutes = try(network_interface.value.public_ip_address_idle_timeout_in_minutes, null)
          }
        }
      }
    }
  }
  tags = var.tags
}