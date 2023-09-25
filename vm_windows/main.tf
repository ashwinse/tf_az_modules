resource "azurerm_windows_virtual_machine" "vmw" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  size                       = var.size           # "Standard_F2"
  admin_username             = var.admin_username # "adminuser"
  admin_password             = var.admin_password # "P@$$w0rd1234!"
  availability_set_id        = var.availability_set_id
  edge_zone                  = var.edge_zone
  zone                       = var.zone
  encryption_at_host_enabled = var.encryption_at_host_enabled
  hotpatching_enabled        = var.hotpatching_enabled
  priority                   = var.priority
  timezone                   = var.timezone
  user_data                  = var.user_data
  computer_name              = var.host_name
  enable_automatic_updates   = var.enable_automatic_updates
  provision_vm_agent         = var.provision_vm_agent
  network_interface_ids      = var.network_interface_ids
  patch_mode                 = var.patch_mode
  custom_data                = var.custom_data
  source_image_id            = var.source_image_id

  os_disk {
    caching              = var.os_disk_caching      # "ReadWrite"
    storage_account_type = var.storage_account_type # "Standard_LRS"
    disk_size_gb         = var.disk_size_gb
    name                 = var.os_disk_name
  }

  dynamic "plan" {
    for_each = var.is_image_from_marketplace == true ? [1] : []
    content {
      name      = var.plan_name
      publisher = var.plan_publisher
      product   = var.plan_product
    }
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_id == null ? [1] : []
    content {
      publisher = var.content_publisher # "MicrosoftWindowsServer"
      offer     = var.content_offer     # "WindowsServer"
      sku       = var.content_sku       # "2016-Datacenter"
      version   = var.content_version   # "latest"
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.is_boot_diagnostics_required == true ? [1] : []
    content {
      storage_account_uri = var.storage_uri
    }
  }
  tags = var.tags
}