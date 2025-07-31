locals {
  no_of_sessions = { for elements in range(var.no_of_sessions) : elements => elements }
}

resource "azurerm_virtual_desktop_host_pool" "wvdpool" {
  location                         = var.location
  resource_group_name              = var.resource_group_name
  name                             = var.name
  validate_environment             = var.validate_environment
  type                             = var.type
  maximum_sessions_allowed         = var.maximum_sessions_allowed
  load_balancer_type               = var.load_balancer_type
  personal_desktop_assignment_type = var.personal_desktop_assignment_type
  custom_rdp_properties            = var.custom_rdp_properties
  tags                             = var.tags
  lifecycle {
    ignore_changes = [ tags ]
  }
}


# resource "azurerm_virtual_desktop_host_pool_registration_info" "wvdpool" {
#   hostpool_id     = azurerm_virtual_desktop_host_pool.wvdpool.id
#   expiration_date = var.expiration_date #"2022-01-01T23:40:52Z"
# }

resource "azurerm_windows_virtual_machine" "avd_vm" {
  for_each = local.no_of_sessions
  name                  = "${var.prefix}-${each.key}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  license_type               = "Windows_Client"
  network_interface_ids = ["${azurerm_network_interface.avd_vm_nic[each.key].*.id[0]}"]
  provision_vm_agent    = true
  secure_boot_enabled = true
  vtpm_enabled               = true
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  source_image_id       = var.source_image_id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  lifecycle {
    ignore_changes = [ tags, identity, timeouts, additional_capabilities, boot_diagnostics ]
  }
  depends_on = [
    azurerm_network_interface.avd_vm_nic
  ]
}
resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  for_each = local.no_of_sessions
  name                       = "Microsoft.PowerShell.DSC"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm[each.key].*.id[0]
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.02599.267.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "hostPoolName":"${azurerm_virtual_desktop_host_pool.wvdpool.name}",
        "UseAgentDownloadEndpoint"               : true,
        "aadJoin"                                : true,
        "aadJoinPreview"                         : false
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${var.registration_token}"
    }
  }
PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [ tags, timeouts, settings, protected_settings ]
  }
  depends_on = [
    azurerm_virtual_machine_extension.domain_join,
    azurerm_virtual_desktop_host_pool.wvdpool
  ]
}

resource "azurerm_virtual_machine_extension" "domain_join" {
  for_each = local.no_of_sessions
  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm[each.key].*.id[0]
  type                       = "AADLoginForWindows"
  type_handler_version       = "2.0"
  auto_upgrade_minor_version = true
  publisher = "Microsoft.Azure.ActiveDirectory"
  settings = <<-SETTINGS
    {
      "mdmId": "0000000a-0000-0000-c000-000000000000"
    }
SETTINGS
  lifecycle {
    ignore_changes = [ tags ]
  }
}

resource "azurerm_network_interface" "avd_vm_nic" {
  for_each = local.no_of_sessions
  name                = "${var.prefix}-${each.key}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  lifecycle {
    ignore_changes = [ tags ]
  }
}