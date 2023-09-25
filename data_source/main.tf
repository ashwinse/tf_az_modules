data "azurerm_resource_group" "rg" {
  count = var.is_rg_existing == false ? 0 : 1
  name  = var.existing_resource_group_name
}

data "azurerm_availability_set" "avset" {
  count               = var.is_avset_existing == false ? 0 : 1
  name                = var.existing_avset_name
  resource_group_name = var.existing_resource_group_name
}

data "azurerm_managed_disk" "md" {
  count               = var.is_md_existing == false ? 0 : 1
  name                = var.existing_managed_disk_name
  resource_group_name = var.existing_resource_group_name
}

data "azurerm_public_ip" "pip" {
  count               = var.is_public_ip_existing == false ? 0 : 1
  name                = var.existing_public_ip_name
  resource_group_name = var.existing_resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  count               = var.is_vnet_existing == false ? 0 : 1
  name                = var.existing_virtual_network_name
  resource_group_name = var.existing_resource_group_name
}

data "azurerm_subnet" "subnet" {
  count                = var.is_subnet_existing == false ? 0 : 1
  name                 = var.existing_subnet_name
  virtual_network_name = var.existing_virtual_network_name
  resource_group_name  = var.existing_resource_group_name
}

data "azurerm_network_security_group" "nsg" {
  count               = var.is_nsg_existing == false ? 0 : 1
  name                = var.existing_nsg_name
  resource_group_name = var.existing_resource_group_name
}

data "azurerm_route_table" "rt" {
  count               = var.is_rt_existing == false ? 0 : 1
  name                = var.existing_route_table_name
  resource_group_name = var.existing_resource_group_name
}

data "azurerm_network_interface" "nic" {
  count               = var.is_nic_existing == false ? 0 : 1
  name                = var.existing_network_interface_name
  resource_group_name = var.existing_resource_group_name
}