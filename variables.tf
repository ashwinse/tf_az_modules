# variable "subscription_id" {}
# variable "client_id" {}
# variable "client_secret" {}
# variable "object_id" {}
# variable "tenant_id" {}


# variable "location" {}
# variable "prefix" {}
# variable "ssh_public_key" {
#   default = null
# }
# variable "tags" {
#   type    = map(any)
#   default = { "Environment" = "test", "Agent" = "tf", "Owner" = "Ashwin" }
# }





############## RG ####################
variable "resource_group" {
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(any))
  }))
  default = {}
}

################### PUBLIC IP ADDRESS ###################

variable "public_ip" {
  type = map(object({
    name                = string
    location            = optional(string)
    resource_group_name = optional(string)
    allocation_method   = string
    domain_name_label   = optional(string)
    tags                = optional(map(any))
  }))
  default = {}
}

###################### VIRTUAL NETWORK ###########################
variable "vnet" {
  type = map(object({
    name                = string
    location            = optional(string)
    resource_group_name = optional(string)
    address_space       = list(string)
    tags                = optional(map(any))
  }))
  default = {}
}

###################### SUBNET ###########################

variable "subnets" {
  type = map(object({
    name                 = string
    resource_group_name  = optional(string)
    virtual_network_name = optional(string)
    service_endpoints    = optional(list(string))
    address_prefixes     = list(string)
    tags                 = optional(map(any))
  }))
  default = {}
}

###################### AVAILABILITY SET ###########################

variable "avsets" {
  type = map(object({
    name                        = string
    location                    = optional(string)
    resource_group_name         = optional(string)
    managed                     = optional(bool, true)
    platform_fault_domain_count = optional(number, 2)
  }))
}

###################### VMS ###########################
variable "vms" {
  type = map(object({
    name                            = string
    location                        = optional(string)
    resource_group_name             = optional(string)
    os_type                         = string
    size                            = string
    admin_username                  = string
    admin_password                  = string
    disable_password_authentication = optional(bool, false)
    availability_set_id             = optional(string)
    content_publisher               = optional(string)
    content_offer                   = optional(string)
    content_sku                     = optional(string)
    content_version                 = optional(string)
    edge_zone                       = optional(string)
    disk_size_gb                    = optional(number)
    host_name                       = optional(string)
    zone                            = optional(string)
    encryption_at_host_enabled      = optional(bool)
    hotpatching_enabled             = optional(bool)
    priority                        = optional(string)
    timezone                        = optional(string)
    user_data                       = optional(string)
    computer_name                   = optional(string)
    enable_automatic_updates        = optional(bool)
    provision_vm_agent              = optional(bool)
    network_interface_ids = map(object({
      nic_name                      = string
      enable_ip_forwarding          = optional(string)
      enable_accelerated_networking = optional(string)
      ip_configuration_name         = string
      private_ip_address_allocation = string
      private_ip_address            = optional(string)
      subnet_id                     = optional(string)
      virtual_network_name          = optional(string)
      public_ip_address_id          = optional(string)
      tags                          = optional(map(any))
      is_subnet_existing            = optional(bool, true)
      is_public_ip_existing         = optional(bool, false)
    }))
    managed_disks = optional(map(object({
      name                      = string
      storage_account_type      = string
      create_option             = string
      disk_size_gb              = optional(number)
      os_type                   = optional(string)
      max_shares                = optional(number)
      tags                      = optional(map(any))
      lun                       = string
      caching                   = string
      write_accelerator_enabled = optional(string)
      storage_account_id        = optional(string)
      source_uri                = optional(string)
      source_resource_id        = optional(string)
      image_reference_id        = optional(string)
    })), {})
    patch_mode                   = optional(string)
    custom_data                  = optional(string)
    source_image_id              = optional(string)
    storage_account_type         = optional(string)
    os_disk_name                 = optional(string)
    os_disk_caching              = optional(string)
    is_image_from_marketplace    = optional(bool, false)
    plan                         = optional(map(any))
    source_image_reference       = optional(map(any))
    is_boot_diagnostics_required = optional(bool, false)
    storage_uri                  = optional(string)
    tags                         = optional(map(any))
  }))
  default = {}
}



variable "vmss" {
  type = map(object({
    name                                   = string
    resource_group_name                    = optional(string)
    location                               = optional(string)
    sku                                    = string
    instances                              = string
    admin_password                         = string
    admin_username                         = string
    disable_password_authentication        = optional(bool, false)
    public_key                             = optional(string)
    automatic_instance_repair_enabled      = optional(bool)
    automatic_instance_repair_grace_period = optional(string)
    is_automatic_os_upgrade_policy         = optional(bool, false)
    disable_automatic_rollback             = optional(string)
    enable_automatic_os_upgrade            = optional(string)
    boot_diagnostics_storage_account_uri   = optional(string)
    capacity_reservation_group_id          = optional(string)
    custom_data                            = optional(string)
    computer_name_prefix                   = optional(string)
    is_data_disk_required                  = optional(bool, false)
    data_disk_settings = optional(list(object({
      name                      = string
      caching                   = optional(string, "ReadWrite")
      create_option             = optional(string, "Empty")
      disk_size_gb              = optional(string)
      storage_account_type      = optional(string)
      lun                       = optional(string)
      disk_encryption_set_id    = optional(string)
      write_accelerator_enabled = optional(bool, false)
    })), [])
    edge_zone                                    = optional(string)
    enable_automatic_updates                     = optional(string)
    encryption_at_host_enabled                   = optional(bool, false)
    eviction_policy                              = optional(string)
    is_gallery_application                       = optional(bool, false)
    gallery_application_version_id               = optional(string)
    gallery_application_configuration_blob_uri   = optional(string)
    gallery_application_order                    = optional(string)
    health_probe_id                              = optional(string)
    host_group_id                                = optional(string)
    is_identity                                  = optional(bool, false)
    license_type                                 = optional(string)
    overprovision                                = optional(string)
    identity_type                                = optional(string)
    identity_ids                                 = optional(string)
    overprovision                                = optional(string)
    is_image_from_marketplace                    = optional(bool, false)
    plan_name                                    = optional(string)
    plan_publisher                               = optional(string)
    plan_product                                 = optional(string)
    platform_fault_domain_count                  = optional(string)
    priority                                     = optional(string)
    provision_vm_agent                           = optional(string)
    proximity_placement_group_id                 = optional(string)
    max_batch_instance_percent                   = optional(string)
    max_unhealthy_instance_percent               = optional(string)
    max_unhealthy_upgraded_instance_percent      = optional(string)
    pause_time_between_batches                   = optional(string)
    rolling_upgrade_policy                       = optional(string)
    is_scale_in                                  = optional(bool, false)
    scale_in_rule                                = optional(string)
    scale_in_force_deletion_enabled              = optional(bool, false)
    secure_boot_enabled                          = optional(bool, false)
    single_placement_group                       = optional(string)
    source_image_id                              = optional(string)
    content_publisher                            = optional(string)
    content_offer                                = optional(string)
    content_sku                                  = optional(string)
    content_version                              = optional(string)
    spot_restore_enabled                         = optional(bool, false)
    spot_restore_timeout                         = optional(string)
    termination_notification_enabled             = optional(bool, false)
    termination_notification_timeout             = optional(string)
    timezone                                     = optional(string)
    upgrade_mode                                 = optional(string)
    user_data                                    = optional(string)
    vtpm_enabled                                 = optional(bool)
    zone_balance                                 = optional(string)
    zones                                        = optional(string)
    os_disk_caching                              = optional(string)
    storage_account_type                         = optional(string)
    disk_size_gb                                 = optional(string)
    write_accelerator_enabled                    = optional(bool)
    security_encryption_type                     = optional(string)
    secure_vm_disk_encryption_set_id             = optional(string)
    network_interface_name                       = string
    dns_servers                                  = optional(string)
    enable_accelerated_networking                = optional(string)
    enable_ip_forwarding                         = optional(string)
    network_security_group_id                    = optional(string)
    application_gateway_backend_address_pool_ids = optional(list(string))
    application_security_group_ids               = optional(list(string))
    load_balancer_backend_address_pool_ids       = optional(list(string))
    load_balancer_inbound_nat_rules_ids          = optional(list(string))
    ip_configuration_version                     = optional(string, "IPv4")
    subnet_id                                    = optional(string)
    is_public_ip_address                         = optional(bool, false)
    public_ip_address_name                       = optional(string)
    public_ip_address_domain_name_label          = optional(string)
    public_ip_address_idle_timeout_in_minutes    = optional(string)
    is_additional_nic_required                   = optional(bool, false)
    subnet_info = optional(map(object({
      name                 = optional(string)
      virtual_network_name = optional(string)
      resource_group_name  = optional(string)
    })), {})
    additional_nic_settings = optional(list(object({
      name                                         = string
      primary                                      = optional(bool, false)
      dns_servers                                  = optional(list(string))
      enable_accelerated_networking                = optional(string)
      enable_ip_forwarding                         = optional(string)
      network_security_group_id                    = optional(string)
      subnet_id                                    = optional(string)
      application_gateway_backend_address_pool_ids = optional(list(string))
      application_security_group_ids               = optional(list(string))
      load_balancer_backend_address_pool_ids       = optional(list(string))
      load_balancer_inbound_nat_rules_ids          = optional(list(string))
      version                                      = optional(string)
      ip_configuration_name                        = optional(string)
      is_public_ip_address                         = optional(bool, false)
      public_ip_address_name                       = optional(string)
      public_ip_address_domain_name_label          = optional(string)
      public_ip_address_idle_timeout_in_minutes    = optional(string)
    })), [])
    tags = optional(map(any))
  }))
  default = {}
}