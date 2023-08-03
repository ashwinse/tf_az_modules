module "rg" {
  source   = "git::https://github.com/ashwinse/tf_az_modules.git//resource_group?ref=main"
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

resource "random_id" "id" {
  keepers = {
    group_name = "abcdefghijklmnopqrstuvwxyz1234567890"
  }
  byte_length = 8
}
/*
module "vnet" {
  source              = "git::https://github.com/ashwinse/tf_az_modules.git//vnet?ref=main"
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
  source               = "git::https://github.com/ashwinse/tf_az_modules.git//subnet?ref=main"
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
  source                        = "git::https://github.com/ashwinse/tf_az_modules.git//route_table?ref=main"
  name                          = "${var.prefix}-rt"
  location                      = module.rg.location
  resource_group_name           = module.rg.name
  tags                          = var.tags
  disable_bgp_route_propagation = null
}

module "route" {
  source                 = "git::https://github.com/ashwinse/tf_az_modules.git//route?ref=main"
  name                   = "${var.prefix}-rtr"
  resource_group_name    = module.rg.name
  route_table_name       = module.route_table.name
  address_prefix         = "10.100.0.0/14"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.10.1.1"
}



module "rt_snet_attach" {
  source         = "git::https://github.com/ashwinse/tf_az_modules.git//route_table_subnet_attach?ref=main"
  subnet_id      = module.subnet[0].id
  route_table_id = module.route_table.id
}

module "avs" {
  source                      = "git::https://github.com/ashwinse/tf_az_modules.git//availability_set?ref=main"
  name                        = "${var.prefix}-avs"
  location                    = module.rg.location
  resource_group_name         = module.rg.name
  platform_fault_domain_count = 3
  managed                     = true
  tags                        = var.tags
}



module "ddosplan" {
  source = "git::https://github.com/ashwinse/tf_az_modules.git//ddos_protection_plan?ref=main"
  name                = "${var.prefix}-ddos_p_plan"
  location            = module.rg.location
  resource_group_name = module.rg.name
  tags                = var.tags
}




module "nsg" {
  source              = "git::https://github.com/ashwinse/tf_az_modules.git//nsg?ref=main"
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
  source                      = "git::https://github.com/ashwinse/tf_az_modules.git//nsr?ref=main"
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
  source = "git::https://github.com/ashwinse/tf_az_modules.git//nsg_subnet_attach?ref=main"
  subnet_id                 = module.subnet[0].id
  network_security_group_id = module.nsg.id
}



module "sa" {
  source                   = "git::https://github.com/ashwinse/tf_az_modules.git//storage_account?ref=main"
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
  source              = "git::https://github.com/ashwinse/tf_az_modules.git//public_ip?ref=main"
  name                = "${var.prefix}-pip"
  location            = module.rg.location
  resource_group_name = module.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}${random_id.id.hex}"
  tags                = var.tags
}

module "wnic" {
  source                        = "git::https://github.com/ashwinse/tf_az_modules.git//network_interface?ref=main"
  name                          = "${var.prefix}-wnic"
  location                      = module.rg.location
  resource_group_name           = module.rg.name
  ip_configuration_name         = "internal"
  private_ip_address_allocation = "Dynamic"
  subnet_id                     = module.subnet[0].id
  public_ip_address_id          = module.pip.id
}

module "md" {
  source               = "git::https://github.com/ashwinse/tf_az_modules.git//managed_disk?ref=main"
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
  source                   = "git::https://github.com/ashwinse/tf_az_modules.git//vm_windows?ref=main"
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
  source                        = "git::https://github.com/ashwinse/tf_az_modules.git//network_interface?ref=main"
  name                          = "${var.prefix}-lnic"
  location                      = module.rg.location
  resource_group_name           = module.rg.name
  ip_configuration_name         = "internal"
  private_ip_address_allocation = "Dynamic"
  subnet_id                     = module.subnet[1].id

}

module "vml" {
  source                          = "git::https://github.com/ashwinse/tf_az_modules.git//vm_linux?ref=main"
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
  source = "git::https://github.com/ashwinse/tf_az_modules.git//managed_disk_attach?ref=main" 
  managed_disk_id    = module.md.id
  virtual_machine_id = module.vmw.id
  lun                = "10"
  caching            = "None"
}
module "vml-md" {
  source = "git::https://github.com/ashwinse/tf_az_modules.git//managed_disk_attach?ref=main"
  managed_disk_id    = module.md.id
  virtual_machine_id = module.vml.id
  lun                = "11"
  caching            = "None"
}



module "kv" {
  source                 = "git::https://github.com/ashwinse/tf_az_modules.git//key_vault?ref=main"
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
  source              = "git::https://github.com/ashwinse/tf_az_modules.git//public_ip?ref=main"
  name                = "${var.prefix}-pip2"
  location            = module.rg.location
  resource_group_name = module.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}${random_id.id.hex}"
  tags                = var.tags
}

module "lb" {
  source                         = "./lb" # "git::https://github.com/ashwinse/tf_az_modules.git//lb?ref=main"
  name                           = "${var.prefix}-lb"
  location                       = module.rg.location
  resource_group_name            = module.rg.name
  sku                            = "Basic"
  public_ip_address_id           = module.pip2.id
  tags                           = var.tags
  frontend_ip_configuration_name = "${var.prefix}-cnf-pip"
}

module "lbap" {
  source              = "./lb_backend_address_pool" # "git::https://github.com/ashwinse/tf_az_modules.git//lb_backend_address_pool?ref=main"
  resource_group_name = module.rg.name
  loadbalancer_id     = module.lb.id
  name                = "${var.prefix}-lb-bkpool"
}

module "lbp" {
  source              = "./lb_probe" # "git::https://github.com/ashwinse/tf_az_modules.git//lb_probe?ref=main"
  loadbalancer_id     = module.lb.id
  resource_group_name = module.rg.name
  name                = "ssh_hlth_probe"
  port                = "22"
}


module "lbr" {
  source                         = "./lb_rule" # "git::https://github.com/ashwinse/tf_az_modules.git//lb_rule?ref=main"
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
  source = "./lb_nat_pool" # "git::https://github.com/ashwinse/tf_az_modules.git//lb_nat_pool?ref=main"
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
  source                         = "./lb_nat_rule" # "git::https://github.com/ashwinse/tf_az_modules.git//lb_nat_rule?ref=main"
  resource_group_name            = module.rg.name
  loadbalancer_id                = module.lb.id
  name                           = "${var.prefix}-lb-natrule"
  protocol                       = "Tcp"
  frontend_port                  = 4000
  backend_port                   = 3389
  frontend_ip_configuration_name = "${var.prefix}-cnf-pip"
}

*/