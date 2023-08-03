## Custom Terraform Base modules made for Azure provider
### Status: InProgress

### Usage

~~~
module "rg" {
  source   = "git::https://github.com/ashwinse/tf_az_modules.git//resource_group?ref=main"
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}
~~~

#### LOOPING through Terraform Modules using For-Each
~~~
variable "avsets" {
  type = map(object({
    name                        = string
    managed                     = optional(bool, true)
    platform_fault_domain_count = optional(number, 2)
  }))
}

avsets = {
  avail-zds-adds-01 = {
    name = "avail-01"
  }
  avail-zds-ddc-01 = {
    name = "avail-02"
  }
}


module "avset" {
  source                      = "git::https://github.com/ashwin2se/tf_az_base_modules.git//availability_set?ref=main"
  for_each                    = var.avsets
  name                        = each.value.name
  location                    = module.rg["xxx"].location
  resource_group_name         = module.rg["xxx"].name
  managed                     = each.value.managed
  platform_fault_domain_count = each.value.platform_fault_domain_count
  tags                        = module.rg["xxx"].tags
}
~~~
##### Virtual Network
~~~
module "vnet" {
  source              = "git::https://github.com/ashwinse/tf_az_modules.git//vnet?ref=main"
  name                = "${var.prefix}-vnet"
  location            = module.rg.location
  resource_group_name = module.rg.name
  tags                = var.tags
  address_space       = ["10.11.0.0/16"]
}
~~~

#### LOOPING through Terraform Modules using count

~~~
module "subnet" {
  source               = "git::https://github.com/ashwinse/tf_az_modules.git//subnet?ref=main"
  count                = 2
  name                 = "${var.prefix}-subnet${count.index + 1}"
  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = ["10.11.${count.index + 1}.0/24"]
  # private_endpoint_network_policies_enabled = true
  # private_link_service_network_policies_enabled = true
  # service_endpoints = ["Microsoft.ContainerRegistry", "Microsoft.Sql"]
  # is_delegation = true
  # delegation_name = "delegation"
  # service_delegation_name = "Microsoft.Sql/managedInstances"
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
~~~
