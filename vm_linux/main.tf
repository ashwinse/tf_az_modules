resource "azurerm_linux_virtual_machine" "vml" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size           # "Standard_F2"
  admin_username                  = var.admin_username # "adminuser"
  disable_password_authentication = var.disable_password_authentication
  availability_set_id             = var.availability_set_id
  admin_password                  = var.admin_password # "P@$$w0rd1234!"
  # custom_data                     = var.custom_data
  custom_data                = try(filebase64(var.custom_data), base64encode(var.custom_data), null)
  user_data                  = var.user_data
  edge_zone                  = var.edge_zone
  encryption_at_host_enabled = var.encryption_at_host_enabled
  patch_mode                 = var.patch_mode
  priority                   = var.priority
  zone                       = var.zone
  patch_assessment_mode      = var.patch_assessment_mode
  source_image_id            = var.source_image_id
  computer_name              = var.host_name
  provision_vm_agent         = var.provision_vm_agent
  network_interface_ids      = var.network_interface_ids

  dynamic "admin_ssh_key" {
    for_each = var.disable_password_authentication == true ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.public_key
    }
  }

  os_disk {
    caching              = var.os_disk_caching      # "ReadWrite"
    storage_account_type = var.storage_account_type # "Standard_LRS"
    disk_size_gb         = var.disk_size_gb
    name                 = var.os_disk_name
  }

  dynamic "plan" {
    for_each = var.is_plan_exists == true ? [1] : []
    content {
      name      = var.plan_name
      publisher = var.plan_publisher
      product   = var.plan_product
    }
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_id == null && var.is_image_from_marketplace == true ? [1] : []
    content {
      publisher = var.content_publisher #"Canonical"
      offer     = var.content_offer     #"UbuntuServer"
      sku       = var.content_sku       #"16.04-LTS"
      version   = var.content_version   #"latest"
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.is_boot_diagnostics_required == true ? [1] : []
    content {
      storage_account_uri = var.storage_account_uri
    }
  }

  dynamic "identity" {
    for_each = var.is_identity_required == true ? [1] : []
    content {
      type         = var.msi_type
      identity_ids = var.identity_ids
    }
  }
  tags = var.tags

  lifecycle {
    ignore_changes = [identity, tags]
  }
}