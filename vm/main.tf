

resource "azurerm_virtual_machine" "vm" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = var.network_interface_ids
  vm_size               = var.size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = var.delete_os_disk_on_termination
  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = var.delete_data_disks_on_termination

  availability_set_id = var.availability_set_id
  storage_os_disk {
    name              = var.os_disk_name
    caching           = var.os_disk_caching # "ReadWrite"
    create_option     = var.create_option
    vhd_uri           = var.vhd_uri
    managed_disk_id   = var.managed_disk_id
    managed_disk_type = var.storage_account_type
    disk_size_gb      = var.disk_size_gb
    os_type           = var.os_type
  }
  os_profile {
    computer_name  = var.host_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  storage_image_reference {
    publisher = var.content_publisher # "MicrosoftWindowsServer" "Canonical"
    offer     = var.content_offer     # "WindowsServer" "UbuntuServer"
    sku       = var.content_sku       # "2016-Datacenter" "16.04-LTS"
    version   = var.content_version   # "latest" "latest"
    id        = var.source_image_id
  }

  dynamic "plan" {
    for_each = var.is_image_from_marketplace == true ? [1] : []
    content {
      name      = var.plan_name
      publisher = var.plan_publisher
      product   = var.plan_product
    }
  }

  dynamic "os_profile_linux_config" {
    for_each = var.os_type == "Linux" ? [1] : []
    content {
      disable_password_authentication = var.disable_password_authentication
      dynamic "ssh_keys" {
        for_each = var.disable_password_authentication == true ? [1] : []
        content {
          path     = "/home/${var.admin_username}/.ssh/authorized_keys"
          key_data = var.ssh_public_key
        }
      }
    }
  }

  dynamic "os_profile_windows_config" {
    for_each = var.os_type == "Windows" ? [1] : []
    content {
      provision_vm_agent        = var.provision_vm_agent
      enable_automatic_upgrades = var.enable_automatic_upgrades
    }
  }

  dynamic "storage_data_disk" {
    for_each = var.is_data_disk_required == true ? [
      for s in var.data_disk_settings : {
        name              = s.name
        caching           = s.caching
        create_option     = s.create_option
        disk_size_gb      = s.disk_size_gb
        managed_disk_id   = s.managed_disk_id
        managed_disk_type = s.managed_disk_type
        vhd_uri           = s.vhd_uri
        lun               = s.lun
    }] : []

    content {
      name              = "${var.host_name}${storage_data_disk.value.name}"
      caching           = storage_data_disk.value.caching
      create_option     = storage_data_disk.value.create_option
      disk_size_gb      = storage_data_disk.value.disk_size_gb
      managed_disk_id   = storage_data_disk.value.managed_disk_id
      managed_disk_type = storage_data_disk.value.managed_disk_type
      vhd_uri           = storage_data_disk.value.vhd_uri
      lun               = storage_data_disk.value.lun
    }
  }

  tags = var.tags

  dynamic "boot_diagnostics" {
    for_each = var.is_boot_diagnostics_required == true ? [1] : []
    content {
      enabled     = var.is_boot_diagnostics_required == true ? "1" : "0"
      storage_uri = var.boot_diagnostics_storage_uri
    }
  }
}