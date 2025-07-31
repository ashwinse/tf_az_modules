
# module "azurerm_arm" {
#   source              = "git::https://github.com/onxpress/tf_az_base_modules.git//azurerm_arm?ref=main"
#   depends_on = [ module.rg ]
#   for_each = var.az_arm
#   name                = each.value.name
#   resource_group_name = each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name
#   deployment_mode     = each.value.deployment_mode
#   parameters_content = each.value.parameters_content
#   template_content = each.value.template_content
# }

# module "rg" {
#   # source   = "git::https://github.com/onxpress/tf_az_base_modules.git//resource_group?ref=main"
#   source = "./resource_group"
#   for_each = var.resource_groups
#   name     = each.value.name
#   location = each.value.location
#   tags     = each.value.tags
# }

/*
module "vnet" {
  source              = "git::https://github.com/onxpress/tf_az_base_modules.git//vnet?ref=main"
  name                = "${var.prefix}-vnet"
  location            = module.rg.location
  resource_group_name = module.rg.name
  tags                = var.tags
  address_space       = ["10.11.0.0/16"]
  # flow_timeout_in_minutes = "5"
  # ddos_protection_plan_id = module.ddosplan.id
  # is_ddos_protection_plan_enable = false
}


module "subnet" {
  source               = "git::https://github.com/onxpress/tf_az_base_modules.git//subnet?ref=main"
  count                = 2
  name                 = "${var.prefix}-subnet${count.index + 1}"
  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = ["10.11.${count.index + 1}.0/24"]
  # private_endpoint_network_policies_enabled = true
  # private_link_service_network_policies_enabled = true
  service_endpoints = ["Microsoft.KeyVault"]
  # is_delegation = true
  # delegation_name = "delegation"
  # service_delegation_name = "Microsoft.Sql/managedInstances"
}

module "route_table" {
  source                        = "git::https://github.com/onxpress/tf_az_base_modules.git//route_table?ref=main"
  name                          = "${var.prefix}-rt"
  location                      = module.rg.location
  resource_group_name           = module.rg.name
  tags                          = var.tags
  disable_bgp_route_propagation = null
}

module "route" {
  source                 = "git::https://github.com/onxpress/tf_az_base_modules.git//route?ref=main"
  name                   = "${var.prefix}-rtr"
  resource_group_name    = module.rg.name
  route_table_name       = module.route_table.name
  address_prefix         = "10.100.0.0/14"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.10.1.1"
}



module "rt_snet_attach" {
  source         = "git::https://github.com/onxpress/tf_az_base_modules.git//route_table_subnet_attach?ref=main"
  subnet_id      = module.subnet[0].id
  route_table_id = module.route_table.id
}

module "avs" {
  source                      = "git::https://github.com/onxpress/tf_az_base_modules.git//availability_set?ref=main"
  name                        = "${var.prefix}-avs"
  location                    = module.rg.location
  resource_group_name         = module.rg.name
  platform_fault_domain_count = 3
  managed                     = true
  tags                        = var.tags
}



module "ddosplan" {
  source = "git::https://github.com/onxpress/tf_az_base_modules.git//ddos_protection_plan?ref=main"
  name                = "${var.prefix}-ddos_p_plan"
  location            = module.rg.location
  resource_group_name = module.rg.name
  tags                = var.tags
}




module "nsg" {
  source              = "git::https://github.com/onxpress/tf_az_base_modules.git//nsg?ref=main"
  name                = "${var.prefix}-nsg"
  location            = module.rg.location
  resource_group_name = module.rg.name
  tags                = var.tags
}

locals {
  name                       = ["RDP", "SSH"]
  direction                  = ["Inbound", "Outbound"]
  access                     = ["Allow", "Deny"]
  protocol                   = ["Tcp", "Udp"]
  source_port_range          = ["*", "22"]
  destination_port_range     = ["3389", "22"]
  source_address_prefix      = ["*", "10.0.0.0/24"]
  destination_address_prefix = ["10.0.0.0/24", "*"]
}

module "nsr" {
  source                      = "git::https://github.com/onxpress/tf_az_base_modules.git//nsr?ref=main"
  count                       = 2
  name                        = element(local.name, count.index)
  priority                    = "20${count.index + 1}"
  direction                   = element(local.direction, count.index)
  access                      = element(local.access, count.index)
  protocol                    = element(local.protocol, count.index)
  source_port_range           = element(local.source_port_range, count.index)
  destination_port_range      = element(local.destination_port_range, count.index)
  source_address_prefix       = element(local.source_address_prefix, count.index)
  destination_address_prefix  = element(local.destination_address_prefix, count.index)
  resource_group_name         = module.rg.name
  network_security_group_name = module.nsg.name
}

module "nsg_snet_attach" {
  source = "git::https://github.com/onxpress/tf_az_base_modules.git//nsg_subnet_attach?ref=main"
  subnet_id                 = module.subnet[0].id
  network_security_group_id = module.nsg.id
}



module "sa" {
  source                   = "git::https://github.com/onxpress/tf_az_base_modules.git//storage_account?ref=main"
  name                     = "${var.prefix}sa${random_id.id.hex}"
  location                 = module.rg.location
  resource_group_name      = module.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
  account_kind = "StorageV2"
  access_tier = "Hot"
  is_hns_enabled = true
  is_blob_properties_req =  true
  blob_versioning_enabled = true
  blob_change_feed_enabled = true
  blob_change_feed_retention_in_days = 7
  blob_last_access_time_enabled = false 
  blob_default_service_version = "2020-06-12"
  is_delete_retention_policy_req_blob = true
  delete_retention_policy_days_blob = 10
  is_restore_policy_req_blob = true  # Must be blob_versioning_enabled = true, blob_change_feed_enabled = true
  restore_policy_days_blob = 7
  is_container_delete_retention_policy_req_blob = true
  container_delete_retention_policy_days_blob = 7
  is_cors_rule_req_blob = true
  allowed_headers = ["*"]
  allowed_methods = ["GET", "HEAD", "MERGE", "POST", "PUT"]
  allowed_origins = ["*"]
  exposed_headers = ["*"]
  max_age_in_seconds = 120

} 

module "pip" {
  source              = "git::https://github.com/onxpress/tf_az_base_modules.git//public_ip?ref=main"
  name                = "${var.prefix}-pip"
  location            = module.rg.location
  resource_group_name = module.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}${random_id.id.hex}"
  tags                = var.tags
}

module "wnic" {
  source                        = "git::https://github.com/onxpress/tf_az_base_modules.git//network_interface?ref=main"
  name                          = "${var.prefix}-wnic"
  location                      = module.rg.location
  resource_group_name           = module.rg.name
  ip_configuration_name         = "internal"
  private_ip_address_allocation = "Dynamic"
  subnet_id                     = module.subnet[0].id
  public_ip_address_id          = module.pip.id
}

module "md" {
  source               = "git::https://github.com/onxpress/tf_az_base_modules.git//managed_disk?ref=main"
  name                 = "dd-${var.prefix}-d-01"
  location             = module.rg.location
  resource_group_name  = module.rg.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = 40
  os_type              = "Windows"
  max_shares           = 2
  tags                 = var.tags
}

module "vmw" {
  source                   = "git::https://github.com/onxpress/tf_az_base_modules.git//vm_windows?ref=main"
  name                     = "${var.prefix}-vmw"
  resource_group_name      = module.rg.name
  location                 = module.rg.location
  size                     = "Standard_D2_v2"
  admin_username           = "adminuser"
  admin_password           = "P@$$word1234!!"
  host_name                = "vm2"
  availability_set_id      = module.avs.id
  network_interface_ids    = [module.wnic.id]
  os_disk_caching          = "ReadWrite"
  storage_account_type     = "Standard_LRS"
  disk_size_gb             = 128
  content_publisher        = "MicrosoftWindowsServer"
  content_offer            = "WindowsServer"
  content_sku              = "2016-Datacenter"
  content_version          = "latest"
  enable_automatic_updates = false
  patch_mode               = "AutomaticByPlatform"
  tags                     = var.tags

}


module "lnic" {
  source                        = "git::https://github.com/onxpress/tf_az_base_modules.git//network_interface?ref=main"
  name                          = "${var.prefix}-lnic"
  location                      = module.rg.location
  resource_group_name           = module.rg.name
  ip_configuration_name         = "internal"
  private_ip_address_allocation = "Dynamic"
  subnet_id                     = module.subnet[1].id

}

module "vml" {
  source                          = "git::https://github.com/onxpress/tf_az_base_modules.git//vm_linux?ref=main"
  name                            = "${var.prefix}-vml"
  resource_group_name             = module.rg.name
  location                        = module.rg.location
  size                            = "Standard_A4_v2"
  admin_username                  = "adminuser"
  admin_password                  = "P@$$word1234!!"
  host_name                       = "vm1"
  availability_set_id             = module.avs.id
  network_interface_ids           = [module.lnic.id]
  os_disk_caching                 = "ReadWrite"
  storage_account_type            = "Standard_LRS"
  disk_size_gb                    = 30
  content_publisher               = "Canonical"
  content_offer                   = "UbuntuServer"
  content_sku                     = "16.04-LTS"
  content_version                 = "latest"
  disable_password_authentication = false
  public_key                      = file("./demo_key.pub") # var.ssh_public_key
  tags                            = var.tags
}



module "vmw-md" {
  source = "git::https://github.com/onxpress/tf_az_base_modules.git//managed_disk_attach?ref=main" 
  managed_disk_id    = module.md.id
  virtual_machine_id = module.vmw.id
  lun                = "10"
  caching            = "None"
}
module "vml-md" {
  source = "git::https://github.com/onxpress/tf_az_base_modules.git//managed_disk_attach?ref=main"
  managed_disk_id    = module.md.id
  virtual_machine_id = module.vml.id
  lun                = "11"
  caching            = "None"
}



module "kv" {
  source                 = "git::https://github.com/onxpress/tf_az_base_modules.git//key_vault?ref=main"
  name                   = "${var.prefix}-kv-${random_id.id.hex}"
  location               = module.rg.location
  resource_group_name    = module.rg.name
  tags                   = var.tags
  sku_name               = "standard"
  tenant_id              = var.tenant_id
  enabled_for_deployment = true
  is_network_acls_req    = true
  virtual_network_subnet_ids = [module.subnet[0].id, module.subnet[1].id]
}

module "pip2" {
  source              = "git::https://github.com/onxpress/tf_az_base_modules.git//public_ip?ref=main"
  name                = "${var.prefix}-pip2"
  location            = module.rg.location
  resource_group_name = module.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}${random_id.id.hex}"
  tags                = var.tags
}

module "lb" {
  source                         = "git::https://github.com/onxpress/tf_az_base_modules.git//lb?ref=main"
  name                           = "${var.prefix}-lb"
  location                       = module.rg.location
  resource_group_name            = module.rg.name
  sku                            = "Basic"
  public_ip_address_id           = module.pip2.id
  tags                           = var.tags
  frontend_ip_configuration_name = "${var.prefix}-cnf-pip"
}

module "lbap" {
  source              = "git::https://github.com/onxpress/tf_az_base_modules.git//lb_backend_address_pool?ref=main"
  resource_group_name = module.rg.name
  loadbalancer_id     = module.lb.id
  name                = "${var.prefix}-lb-bkpool"
}

module "lbp" {
  source              = "git::https://github.com/onxpress/tf_az_base_modules.git//lb_probe?ref=main"
  loadbalancer_id     = module.lb.id
  resource_group_name = module.rg.name
  name                = "ssh_hlth_probe"
  port                = "22"
}


module "lbr" {
  source                         = "git::https://github.com/onxpress/tf_az_base_modules.git//lb_rule?ref=main"
  resource_group_name            = module.rg.name
  loadbalancer_id                = module.lb.id
  name                           = "${var.prefix}-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8080
  frontend_ip_configuration_name = "${var.prefix}-cnf-pip"
  backend_address_pool_id        = module.lbap.id
  probe_id                       = module.lbp.id
}

module "lbnp" {
  source = "git::https://github.com/onxpress/tf_az_base_modules.git//lb_nat_pool?ref=main"
  resource_group_name = module.rg.name
  loadbalancer_id = module.lb.id
  name = "${var.prefix}-nat-pool"
  protocol = "Tcp"
  frontend_port_start = 50000
  frontend_port_end = 50019
  backend_port = 22
  frontend_ip_configuration_name = "${var.prefix}-cnf-pip"
}



 module "lbnr" {
  source                         = "git::https://github.com/onxpress/tf_az_base_modules.git//lb_nat_rule?ref=main"
  resource_group_name            = module.rg.name
  loadbalancer_id                = module.lb.id
  name                           = "${var.prefix}-lb-natrule"
  protocol                       = "Tcp"
  frontend_port                  = 4000
  backend_port                   = 3389
  frontend_ip_configuration_name = "${var.prefix}-cnf-pip"
}

*/

############################################## WITH FOR EACH VM DEPLOYMENT #############################################################
/*
resource "random_id" "id" {
  keepers = {
    group_name = "abcdefghijklmnopqrstuvwxyz1234567890"
  }
  byte_length = 3
}

module "rg" {
  source   = "git::https://github.com/onxpress/tf_az_base_modules.git//resource_group?ref=main"
  for_each = var.resource_group
  name     = each.value.name
  location = each.value.location
  tags     = each.value.tags
}


module "vnet" {
  source              = "git::https://github.com/onxpress/tf_az_base_modules.git//vnet?ref=main"
  for_each            = var.vnet
  name                = each.value.name
  location            = module.rg["rg0"].location
  resource_group_name = module.rg["rg0"].name
  address_space       = each.value.address_space
  tags                = module.rg["rg0"].tags
}

module "subnet" {
  source               = "git::https://github.com/onxpress/tf_az_base_modules.git//subnet?ref=main"
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = module.rg["rg0"].name
  virtual_network_name = module.vnet["vnet0"].name
  address_prefixes     = each.value.address_prefixes
}

module "pip" {
  source              = "git::https://github.com/onxpress/tf_az_base_modules.git//public_ip?ref=main"
  for_each             = var.public_ip
  name                = each.value.name
  location            = module.rg["rg0"].location
  resource_group_name = module.rg["rg0"].name
  allocation_method   = each.value.allocation_method
  domain_name_label   = each.value.domain_name_label == null ? null : "${each.value.domain_name_label}${random_id.id.hex}"
  tags                = module.rg["rg0"].tags
}


module "avset" {
  source                      = "git::https://github.com/onxpress/tf_az_base_modules.git//availability_set?ref=main"
  for_each                    = var.avsets
  name                        = each.value.name
  location                    = module.rg["rg0"].location
  resource_group_name         = module.rg["rg0"].name
  managed                     = each.value.managed
  platform_fault_domain_count = each.value.platform_fault_domain_count
  tags                        = module.rg["rg0"].tags
}

module "vm_pack" {
  source                          = "git::https://github.com/onxpress/tf_az_base_modules.git//vm_pack?ref=main"
  depends_on                      = [module.rg, module.vnet, module.subnet, module.avset, module.image_agreement]
  os_type                         = each.value.os_type
  for_each                        = var.vms
  vm_name                         = each.value.name
  location                        = each.value.location == null ? local.location : each.value.location
  resource_group_name             = each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name
  tags                            = each.value.tags == null ? local.tags : each.value.tags
  availability_set_id             = each.value.availability_set_id == null ? null : merge(module.avset.*...)[each.value.availability_set_id].id
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  host_name                       = each.value.host_name
  network_interface_ids           = each.value.network_interface_ids
  managed_disks                   = each.value.managed_disks
  os_disk_name                    = each.value.os_disk_name == null ? null : "${each.value.os_disk_name}_${random_id.id.hex}"
  os_disk_caching                 = each.value.os_disk_caching
  storage_account_type            = each.value.storage_account_type
  disk_size_gb                    = each.value.disk_size_gb
  content_publisher               = each.value.content_publisher
  content_offer                   = each.value.content_offer
  content_sku                     = each.value.content_sku
  content_version                 = each.value.content_version
  enable_automatic_updates        = each.value.enable_automatic_updates
  patch_mode                      = each.value.patch_mode
  disable_password_authentication = each.value.disable_password_authentication
  data_source_looper              = each.value.network_interface_ids
  is_boot_diagnostics_required    = each.value.is_boot_diagnostics_required
  is_image_from_marketplace       = each.value.is_image_from_marketplace
  is_plan_exists                  = each.value.is_plan_exists
  plan_name                       = each.value.plan_name
  plan_publisher                  = each.value.plan_publisher
  plan_product                    = each.value.plan_product
  storage_uri                     = each.value.storage_uri
  is_identity_required         = each.value.is_identity_required
  msi_type                     = each.value.msi_type
  identity_ids                 = each.value.identity_ids
}
*/

# module "vmssw" {
#   source                     = "./vmss_windows"
#   depends_on                 = [module.rg, module.vnet, module.subnet]
#   for_each                   = var.vmss
#   name                       = each.value.name
#   resource_group_name        = module.rg["rg0"].name
#   location                   = module.rg["rg0"].location
#   sku                        = each.value.sku
#   instances                  = each.value.instances
#   admin_password             = each.value.admin_password
#   admin_username             = each.value.admin_username
#   computer_name_prefix       = each.value.computer_name_prefix
#   is_data_disk_required      = each.value.is_data_disk_required
#   data_disk_settings         = each.value.data_disk_settings
#   content_publisher          = each.value.content_publisher
#   content_offer              = each.value.content_offer
#   content_sku                = each.value.content_sku
#   content_version            = each.value.content_version
#   os_disk_caching            = each.value.os_disk_caching
#   storage_account_type       = each.value.storage_account_type
#   disk_size_gb               = each.value.disk_size_gb
#   network_interface_name     = each.value.network_interface_name
#   subnet_id                  = merge(module.subnet.*...)[each.value.subnet_id].id
#   is_public_ip_address       = each.value.is_public_ip_address
#   public_ip_address_name     = each.value.public_ip_address_name
#   is_additional_nic_required = each.value.is_additional_nic_required
#   subnet_info                = each.value.subnet_info
#   additional_nic_settings    = each.value.additional_nic_settings
#   tags                       = module.rg["rg0"].tags
# }

# module "vmssl" {
#   source                     = "./vmss_linux"
#   depends_on                 = [module.rg, module.vnet, module.subnet]
#   for_each                   = var.vmss
#   name                       = each.value.name
#   resource_group_name        = module.rg["rg0"].name
#   location                   = module.rg["rg0"].location
#   disable_password_authentication = each.value.disable_password_authentication
#   sku                        = each.value.sku
#   instances                  = each.value.instances
#   admin_password             = each.value.admin_password
#   admin_username             = each.value.admin_username
#   computer_name_prefix       = each.value.computer_name_prefix
#   is_data_disk_required      = each.value.is_data_disk_required
#   data_disk_settings         = each.value.data_disk_settings
#   content_publisher          = each.value.content_publisher
#   content_offer              = each.value.content_offer
#   content_sku                = each.value.content_sku
#   content_version            = each.value.content_version
#   os_disk_caching            = each.value.os_disk_caching
#   storage_account_type       = each.value.storage_account_type
#   disk_size_gb               = each.value.disk_size_gb
#   network_interface_name     = each.value.network_interface_name
#   subnet_id                  = merge(module.subnet.*...)[each.value.subnet_id].id
#   is_public_ip_address       = each.value.is_public_ip_address
#   public_ip_address_name     = each.value.public_ip_address_name
#   is_additional_nic_required = each.value.is_additional_nic_required
#   subnet_info                = each.value.subnet_info
#   additional_nic_settings    = each.value.additional_nic_settings
#   tags                       = module.rg["rg0"].tags
# }

# module "vnet_peer" {
#   source              = "git::https://github.com/onxpress/tf_az_base_modules.git//vnet_peering?ref=main"
#   depends_on = [ module.vnet ]
#   providers = {
#     azurerm.hub = azurerm.hub
#   }
#   for_each            = var.vnet_peer
#   name                = each.value.name
#   resource_group_name = each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name
#   hub_resource_group_name = each.value.hub_resource_group_name
#   spoke_virtual_network_name = each.value.spoke_virtual_network_name
#   hub_virtual_network_name = each.value.hub_virtual_network_name
#   allow_forwarded_traffic = each.value.allow_forwarded_traffic
#   envt = each.value.envt
# }

# module "private_endpoint" {
#   # source              = "git::https://github.com/onxpress/tf_az_base_modules.git//vazurerm_arm?ref=main"
#   # depends_on = [ module.rg ]
#   for_each = var.private_endpoint
#   name                = each.value.name
#   location            = each.value.location == null ? local.location : each.value.location
#   resource_group_name = each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name
#   tags            = each.value.tags == null ? local.tags : each.value.tags
#   virtual_network_name = each.value.virtual_network_name
#   subnet_id     = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${each.value.virtual_network_name}/subnets/${each.value.subnet_id}"
#   private_connection_resource_id = each.value.private_connection_resource_key
#   is_manual_connection = each.value.is_manual_connection
#   subresource_names = each.value.subresource_names
#   request_message = each.value.request_message
#   private_dns_zone_group = each.value.private_dns_zone_group
#   ip_configurations = each.value.ip_configuration
#   custom_network_interface_name = each.value.custom_network_interface_name
# }

# module "private_dns_zone" {
#   source = "../private_dns_zone"
#   for_each = var.private_dns_zone
#   name = each.value.name
#   resource_group_name = each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name
#   tags            = each.value.tags == null ? local.tags : each.value.tags
# }

# module "pdz_vnet_link" {
#   source = "../private_dns_zone_virtual_network_link"
#   for_each = var.pdz_vnet_link
#   name = each.value.name
#   resource_group_name = each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name
#   private_dns_zone_name = each.value.private_dns_zone_name
#   # virtual_network_id = merge(module.vnet.*...)[each.value.virtual_network_id].id
#   virtual_network_id = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${each.value.virtual_network_name}"
#   tags            = each.value.tags == null ? local.tags : each.value.tags
# }

# module "virtual_network_gateway" {
#   # source              = "git::https://github.com/onxpress/tf_az_base_modules.git//vazurerm_arm?ref=main"
#   source = "../virtual_network_gateway"
#   depends_on = [ module.pip ]
#   for_each = var.vpn_gateway
#   name                = each.value.name
#   location            = each.value.location == null ? local.location : each.value.location
#   resource_group_name = each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name
#   tags            = each.value.tags == null ? local.tags : each.value.tags
#   type = each.value.type
#   vpn_type = each.value.vpn_type
#   active_active = each.value.active_active
#   enable_bgp = each.value.enable_bgp
#   sku = each.value.sku
#   default_local_network_gateway_id = each.value.default_local_network_gateway_id
#   edge_zone = each.value.edge_zone
#   generation = each.value.generation
#   private_ip_address_enabled = each.value.private_ip_address_enabled
#   ip_configurations = each.value.ip_configurations
#   vpn_client_configuration = each.value.vpn_client_configuration
#   bgp_settings = each.value.bgp_settings
#   subscription_id = data.azurerm_subscription.current.subscription_id
# }

# module "local_network_gateway" {
#   # source              = "git::https://github.com/onxpress/tf_az_base_modules.git//public_ip?ref=v0.0.3"
#   source = "../local_network_gateway"
#   for_each = var.ln_gateway
#   name                = each.value.name
#   location            = each.value.location == null ? local.location : each.value.location
#   resource_group_name = each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name
#   tags            = each.value.tags == null ? local.tags : each.value.tags
#   gateway_address     = each.value.gateway_address
#   gateway_fqdn = each.value.gateway_fqdn
#   address_space       = each.value.address_space
# }

# module "gw_conn" {
#   # source              = "git::https://github.com/onxpress/tf_az_base_modules.git//vn_gateway_connection?ref=main"
#   for_each = var.gw_connection
#   name                = each.value.name
#   location            = each.value.location == null ? local.location : each.value.location
#   resource_group_name = each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name
#   tags            = each.value.tags == null ? local.tags : each.value.tags
#   type                       = each.value.type
#   connection_protocol = each.value.connection_protocol
#   ipsec_policy = each.value.ipsec_policy
#   virtual_network_gateway_id = merge(module.virtual_network_gateway.*...)[each.value.virtual_network_gateway_id].id
#   local_network_gateway_id   = merge(module.local_network_gateway.*...)[each.value.local_network_gateway_id].id
#   shared_key = each.value.shared_key
# }
#
# module "firewall" {
#   source              = "git::https://github.com/onxpress/tf_az_base_modules.git//firewall?ref=v0.0.5"
#   for_each            = var.firewall
#   name                = each.value.name
#   location            = each.value.location == null ? local.location : each.value.location
#   resource_group_name = each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name
#   sku_tier            = each.value.sku_tier
#   sku_name            = each.value.sku_name
#   firewall_policy_id  = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/firewallPolicies/%s", data.azurerm_subscription.current.subscription_id, each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name, each.value.firewall_policy_name)
#   zones               = each.value.zones
#   ip_config           = each.value.ip_config
#   tags                = each.value.tags == null ? local.tags : each.value.tags
#   subscription_id     = data.azurerm_subscription.current.subscription_id
# }
#
# module "fw_policy" {
#   # source              = "git::https://github.com/onxpress/tf_az_base_modules.git//firewall_policy?ref=main"
#   for_each            = var.fw_policy
#   name                = each.value.name
#   location            = each.value.location == null ? local.location : each.value.location
#   resource_group_name = each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name
#   sku                 = each.value.sku
#   auto_learn_private_ranges_enabled = each.value.auto_learn_private_ranges_enabled
#   dns                 = each.value.dns
#   tags                = each.value.tags == null ? local.tags : each.value.tags
# }

# module "fw_rule_coll" {
#   # source              = "git::https://github.com/onxpress/tf_az_base_modules.git//firewall_policy_rule_collection_group?ref=main"
#   depends_on = [ module.fw_policy ]
#   for_each            = var.fw_rule_coll
#   name                = each.value.name
#   firewall_policy_id  = merge(module.fw_policy.*...)[each.value.firewall_policy_key].id
#   priority            = each.value.priority
#   application_rule_collection = each.value.application_rule_collection
#   network_rule_collection = each.value.network_rule_collection
#   nat_rule_collection = each.value.nat_rule_collection
# }
# data "azuread_client_config" "current" {}

#############################################  CDN FRONTFOOR #################################################################

# module "cdn_fd_profile" {
#   source                   = "git::https://github.com/onxpress/tf_az_base_modules.git//cdn_frontdoor_profile?ref=IAC-28-Frontdoor"
#   depends_on               = [module.rg]
#   for_each                 = var.frontdoor_profile
#   name                     = each.value.name
#   resource_group_name      = each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name
#   sku_name                 = each.value.sku_name
#   response_timeout_seconds = each.value.response_timeout_seconds
#   tags                     = each.value.tags == null ? local.tags : each.value.tags
# }

# module "cdn_fd_ep" {
#   source                   = "git::https://github.com/onxpress/tf_az_base_modules.git//cdn_frontdoor_endpoint?ref=IAC-28-Frontdoor"
#   depends_on               = [module.cdn_fd_profile]
#   for_each                 = var.fd_eps
#   name                     = each.value.name
#   cdn_frontdoor_profile_id = merge(module.cdn_fd_profile.*...)[each.value.cdn_frontdoor_profile_id].id
#   tags                     = each.value.tags == null ? local.tags : each.value.tags
# }

# module "cdn_fd_og" {
#   source                             = "git::https://github.com/onxpress/tf_az_base_modules.git//cdn_frontdoor_origin_group?ref=IAC-28-Frontdoor"
#   depends_on                         = [module.cdn_fd_profile]
#   for_each                           = var.fd_ogs
#   name                               = each.value.name
#   cdn_frontdoor_profile_id           = merge(module.cdn_fd_profile.*...)[each.value.cdn_frontdoor_profile_id].id
#   session_affinity_enabled           = each.value.session_affinity_enabled
#   health_probe                       = each.value.health_probe
#   additional_latency_in_milliseconds = each.value.additional_latency_in_milliseconds
#   sample_size                        = each.value.sample_size
#   successful_samples_required        = each.value.successful_samples_required
# }

# module "cdn_fd_origins" {
#   source                         = "git::https://github.com/onxpress/tf_az_base_modules.git//cdn_frontdoor_origin?ref=IAC-28-Frontdoor"
#   depends_on                     = [module.cdn_fd_profile, module.cdn_fd_og]
#   for_each                       = var.fd_origins
#   name                           = each.value.name
#   cdn_frontdoor_origin_group_id  = merge(module.cdn_fd_og.*...)[each.value.cdn_frontdoor_origin_group_id].id
#   is_enabled                     = each.value.is_enabled
#   certificate_name_check_enabled = each.value.certificate_name_check_enabled
#   host_name                      = each.value.host_name
#   http_port                      = each.value.http_port
#   https_port                     = each.value.https_port
#   origin_host_header             = each.value.origin_host_header
#   priority                       = each.value.priority
#   weight                         = each.value.weight
# }

# module "cdn_fd_custom_domains" {
#   source                   = "git::https://github.com/onxpress/tf_az_base_modules.git//cdn_frontdoor_custom_domain?ref=IAC-28-Frontdoor"
#   depends_on               = [module.cdn_fd_profile]
#   for_each                 = var.fd_custom_domains
#   name                     = each.value.name
#   cdn_frontdoor_profile_id = merge(module.cdn_fd_profile.*...)[each.value.cdn_frontdoor_profile_id].id
#   dns_zone_id              = each.value.dns_zone_id
#   host_name                = each.value.host_name
#   certificate_type         = each.value.certificate_type
#   minimum_tls_version      = each.value.minimum_tls_version
# }

# module "cdn_frontdoor_route" {
#   source                          = "git::https://github.com/onxpress/tf_az_base_modules.git//cdn_frontdoor_route?ref=IAC-28-Frontdoor"
#   depends_on                      = [module.cdn_fd_ep, module.cdn_fd_og, module.cdn_fd_origins]
#   for_each                        = var.fd_routes
#   name                            = each.value.name
#   cdn_frontdoor_endpoint_id       = merge(module.cdn_fd_ep.*...)[each.value.cdn_frontdoor_endpoint_id].id
#   cdn_frontdoor_origin_group_id   = merge(module.cdn_fd_og.*...)[each.value.cdn_frontdoor_origin_group_id].id
#   cdn_frontdoor_origin_ids        = []
#   is_route_enabled                = each.value.is_route_enabled
#   forwarding_protocol             = each.value.forwarding_protocol
#   https_redirect_enabled          = each.value.https_redirect_enabled
#   patterns_to_match               = each.value.patterns_to_match
#   supported_protocols             = each.value.supported_protocols
#   cdn_frontdoor_custom_domain_ids = [merge(module.cdn_fd_custom_domains.*...)[each.value.cdn_frontdoor_custom_domain_ids].id]
#   link_to_default_domain          = each.value.link_to_default_domain
#   cache                           = each.value.cache
# }