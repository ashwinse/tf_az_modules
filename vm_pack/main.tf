module "data_source" {
  source                        = "git::https://github.com/onxpress/tf_az_base_modules.git//data_source?ref=main"
  for_each                      = var.data_source_looper
  is_vnet_existing              = try(each.value.is_vnet_existing, false)
  is_subnet_existing            = try(each.value.is_subnet_existing, false)
  is_public_ip_existing         = try(each.value.is_public_ip_existing, false)
  existing_managed_disk_name    = try(each.value.managed_disk_name, null)
  existing_subnet_name          = try(each.value.subnet_id, null)
  existing_virtual_network_name = try(each.value.virtual_network_name, null)
  existing_public_ip_name       = try(each.value.public_ip_address_id, null)
  existing_resource_group_name  = try(var.resource_group_name, null)
}



module "nic" {
  source                        = "git::https://github.com/onxpress/tf_az_base_modules.git//network_interface?ref=main"
  for_each                      = var.network_interface_ids
  depends_on                    = [module.data_source]
  name                          = each.value.nic_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_ip_forwarding          = each.value.enable_ip_forwarding
  enable_accelerated_networking = each.value.enable_accelerated_networking
  ip_configuration_name         = each.value.ip_configuration_name
  private_ip_address_allocation = each.value.private_ip_address_allocation
  private_ip_address            = each.value.private_ip_address
  subnet_id                     = merge(module.data_source.*...)[each.value.nic_name].subnet_ids
  public_ip_address_id          = try(merge(module.data_source.*...)[each.value.nic_name].public_ip_address_ids, null)
  tags                          = each.value.tags
}


module "vmw" {
  source                       = "git::https://github.com/onxpress/tf_az_base_modules.git//vm_windows?ref=main"
  depends_on                   = [module.nic, module.data_source]
  count                        = var.os_type == "Windows" ? 1 : 0
  name                         = var.vm_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  size                         = var.size           # "Standard_F2"
  admin_username               = var.admin_username # "adminuser"
  admin_password               = var.admin_password # "P@$$w0rd1234!"
  availability_set_id          = var.availability_set_id
  edge_zone                    = var.edge_zone
  zone                         = var.zone
  encryption_at_host_enabled   = var.encryption_at_host_enabled
  hotpatching_enabled          = var.hotpatching_enabled
  priority                     = var.priority
  timezone                     = var.timezone
  user_data                    = var.user_data
  host_name                    = var.host_name
  enable_automatic_updates     = var.enable_automatic_updates
  provision_vm_agent           = var.provision_vm_agent
  network_interface_ids        = [for nic in keys(var.network_interface_ids) : merge(module.nic.*...)[nic]["id"]]
  patch_mode                   = var.patch_mode
  custom_data                  = var.custom_data
  source_image_id              = var.source_image_id
  os_disk_name                 = var.os_disk_name
  os_disk_caching              = var.os_disk_caching      # "ReadWrite"
  storage_account_type         = var.storage_account_type # "Standard_LRS"
  disk_size_gb                 = var.disk_size_gb
  is_image_from_marketplace    = var.is_image_from_marketplace
  plan_name                    = var.plan_name
  plan_publisher               = var.plan_publisher
  plan_product                 = var.plan_product
  content_publisher            = var.content_publisher
  content_offer                = var.content_offer
  content_sku                  = var.content_sku
  content_version              = var.content_version
  is_boot_diagnostics_required = var.is_boot_diagnostics_required
  storage_uri                  = var.storage_uri
  tags                         = var.tags
}


module "vml" {
  source                          = "git::https://github.com/onxpress/tf_az_base_modules.git//vm_linux?ref=main"
  depends_on                      = [module.nic, module.data_source]
  count                           = var.os_type == "Linux" ? 1 : 0
  name                            = var.vm_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.size           # "Standard_F2"
  admin_username                  = var.admin_username # "adminuser"
  disable_password_authentication = var.disable_password_authentication
  availability_set_id             = var.availability_set_id
  admin_password                  = var.admin_password # "P@$$w0rd1234!"
  custom_data                     = var.custom_data
  user_data                       = var.user_data
  edge_zone                       = var.edge_zone
  encryption_at_host_enabled      = var.encryption_at_host_enabled
  patch_mode                      = var.patch_mode
  priority                        = var.priority
  zone                            = var.zone
  patch_assessment_mode           = var.patch_assessment_mode
  source_image_id                 = var.source_image_id
  host_name                       = var.host_name
  provision_vm_agent              = var.provision_vm_agent
  network_interface_ids           = [for nic in keys(var.network_interface_ids) : merge(module.nic.*...)[nic]["id"]]
  tags                            = var.tags
  public_key                      = var.public_key
  os_disk_name                    = var.os_disk_name
  os_disk_caching                 = var.os_disk_caching
  storage_account_type            = var.storage_account_type
  disk_size_gb                    = var.disk_size_gb
  is_image_from_marketplace       = var.is_image_from_marketplace
  plan_name                       = var.plan_name
  plan_publisher                  = var.plan_publisher
  plan_product                    = var.plan_product
  content_publisher               = var.content_publisher
  content_offer                   = var.content_offer
  content_sku                     = var.content_sku
  content_version                 = var.content_version
  is_boot_diagnostics_required    = var.is_boot_diagnostics_required
  storage_account_uri             = var.storage_uri
}



module "md" {
  source               = "git::https://github.com/onxpress/tf_az_base_modules.git//managed_disk?ref=main"
  for_each             = var.managed_disks
  depends_on           = [module.data_source]
  name                 = each.value.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  source_resource_id   = each.value.source_resource_id
  image_reference_id   = each.value.image_reference_id
  source_uri           = each.value.source_uri
  disk_size_gb         = each.value.disk_size_gb
  os_type              = each.value.os_type
  storage_account_id   = each.value.storage_account_id
  max_shares           = each.value.max_shares
  tags                 = each.value.tags
}

module "vm-md" {
  source                    = "git::https://github.com/onxpress/tf_az_base_modules.git//managed_disk_attach?ref=main"
  depends_on                = [module.vml, module.vmw, module.md, module.data_source]
  for_each                  = var.managed_disks
  managed_disk_id           = merge(module.md.*...)[each.value.name]["id"]
  virtual_machine_id        = try(module.vmw[0].id, module.vml[0].id)
  lun                       = each.value.lun
  caching                   = each.value.caching
  create_option             = "Attach"
  write_accelerator_enabled = each.value.write_accelerator_enabled
}