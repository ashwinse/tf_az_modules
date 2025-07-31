############## Global ####################
variable "location" {
  type = any
}
variable "resource_group_name" {
  type = any
}
variable "tags" {
  type = map(any)
}

############## RG ####################
variable "resource_group" {
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(any))
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
    dns_servers         = optional(list(string))
    tags                = optional(map(any))
  }))
  default = {}
}


###################### VIRTUAL NETWORK PEERING ###########################
variable "vnet_peer" {
  type = map(object({
    name                       = string
    resource_group_name        = optional(string)
    hub_resource_group_name    = optional(string)
    spoke_virtual_network_name = string
    hub_virtual_network_name   = string
    allow_forwarded_traffic    = optional(bool)
    envt                       = string
  }))
  default = {}
}

###################### Public IP #######################

variable "public_ip" {
  type = map(object({
    name                = string
    location            = optional(string)
    resource_group_name = optional(string)
    allocation_method   = string
    sku                 = optional(string, "Standard")
    domain_name_label   = optional(string)
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

###################### ROUTE TABLE ###########################
variable "route_table" {
  type = map(object({
    name                          = string
    location                      = optional(string)
    resource_group_name           = optional(string)
    disable_bgp_route_propagation = optional(bool)
    tags                          = optional(map(any))
  }))
  default = {}
}

variable "route" {
  type = map(object({
    name                   = string
    resource_group_name    = optional(string)
    subnet_key             = string
    route_table_key        = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
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
    tags                        = optional(map(any))
  }))
  default = {}
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
      ip_configuration_name         = optional(string, "ipconfig")
      private_ip_address_allocation = string
      private_ip_address            = optional(string)
      subnet_id                     = optional(string)
      virtual_network_name          = optional(string)
      public_ip_address_id          = optional(string)
      tags                          = optional(map(any))
      is_subnet_existing            = optional(bool, true)
      is_public_ip_existing         = optional(bool, false)
      ip_configuration              = optional(map(any))
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
    vm_extensions = optional(map(object({
      name                      = string
      virtual_machine_key       = string
      publisher                 = string
      type                      = string
      type_handler_version      = string
      automatic_upgrade_enabled = optional(bool)
      tags                      = optional(map(any))
    })), {})
    patch_mode                   = optional(string)
    custom_data                  = optional(string)
    source_image_id              = optional(string)
    storage_account_type         = optional(string)
    os_disk_name                 = optional(string)
    os_disk_caching              = optional(string)
    is_image_from_marketplace    = optional(bool, false)
    is_plan_exists               = optional(bool, false)
    plan_name                    = optional(string)
    plan_publisher               = optional(string)
    plan_product                 = optional(string)
    source_image_reference       = optional(map(any))
    is_boot_diagnostics_required = optional(bool, false)
    storage_uri                  = optional(string, "https://sabootdiagx.blob.core.windows.net/")
    tags                         = optional(map(any))
    is_identity_required         = optional(string)
    msi_type                     = optional(string)
    identity_ids                 = optional(list(string), null)
  }))
  default = {}
}

variable "image_agreement" {
  type = map(object({
    publisher = string
    offer     = string
    plan      = string
  }))
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


variable "nsgs" {
  type = map(object({
    name                = string
    location            = optional(string)
    resource_group_name = optional(string)
    tags                = optional(map(any))
  }))
  default = {}
}

variable "nsg_snet_attaches" {
  type = map(object({
    subnet_id                 = string
    network_security_group_id = string
  }))
  default = {}
}

variable "nsg_nic_attaches" {
  type = map(object({
    network_interface_name    = string
    network_security_group_id = string
  }))
  default = {}
}

variable "nsr" {
  type = map(object({
    resource_group_name         = optional(string)
    name                        = string
    priority                    = number
    direction                   = string
    access                      = string
    protocol                    = string
    source_port_range           = string
    destination_port_range      = string
    source_address_prefix       = string
    destination_address_prefix  = string
    network_security_group_name = string
  }))
  default = {}
}

variable "storage_account" {
  default = {}
  type = map(object({
    name                     = string
    location                 = optional(string)
    resource_group_name      = optional(string)
    account_tier             = optional(string, "Standard")
    account_replication_type = optional(string, "LRS")
    tags                     = optional(map(any))
  }))
}

variable "fileshare" {
  default = {}
  type = map(object({
    name                 = string
    storage_account_name = string
    quota                = string
  }))
}

variable "app_registration" {
  description = "Az AD object App registration"
  type = map(object({
    display_name = string
    owners       = optional(list(string))
  }))
  default = {}
}

variable "service_principal" {
  description = "Az AD object Service Principal"
  type = map(object({
    application_key              = string
    owners                       = optional(list(string))
    app_role_assignment_required = optional(bool)
    tags                         = optional(map(string))
  }))
  default = {}
}
variable "service_principal_password" {
  description = "Az AD object Service Principal Password"
  type = map(object({
    application_key       = string
    service_principal_key = string
    secret_prefix         = optional(string)
    keyvault_key          = optional(string)
  }))
  default = {}
}

variable "key_vaults" {
  type = map(object({
    name                            = string
    location                        = string
    resource_group_name             = string
    enabled_for_disk_encryption     = optional(bool)
    enabled_for_deployment          = optional(bool)
    enabled_for_template_deployment = optional(bool)
    enable_rbac_authorization       = optional(bool)
    purge_protection_enabled        = optional(bool)
    public_network_access_enabled   = optional(bool)
    soft_delete_retention_days      = optional(number)
    tags                            = optional(map(any))
    sku_name                        = optional(string, "standard")
  }))
  default = {}
}

variable "key_vault_access_policies" {
  type = map(object({
    key_vault_key           = string
    service_principal_key   = string
    key_permissions         = optional(list(string))
    secret_permissions      = optional(list(string))
    certificate_permissions = optional(list(string))
  }))
  default = {}
}
variable "role_assignment" {
  type = map(object({
    scope            = string
    principal_id_key = string
    custom_role_key  = optional(string)
    builtin_role     = optional(string)
  }))
  default = {}
}
###################### AZURE ARM TEMPLATE ###########################

variable "az_arm" {
  type = map(object({
    name                = string
    resource_group_name = optional(string)
    deployment_mode     = string
    parameters_content  = optional(string)
    template_content    = optional(string)
    tags                = optional(map(any))
  }))
  default = {}
}

###################### Private Endpoint #######################

variable "private_endpoint" {
  type = map(object({
    name                            = string
    location                        = optional(string)
    resource_group_name             = optional(string)
    virtual_network_name            = string
    subnet_id                       = string
    private_connection_resource_key = string
    is_manual_connection            = bool
    subresource_names               = optional(list(string))
    request_message                 = optional(string)
    private_dns_zone_group          = optional(map(any))
    ip_configuration                = optional(map(any))
    custom_network_interface_name   = optional(string)
    tags                            = optional(map(any))
  }))
  default = {}
}

###################### Private DNS Zone #######################

variable "private_dns_zone" {
  type = map(object({
    name                = string
    resource_group_name = optional(string)
    tags                = optional(map(any))
  }))
  default = {}
}

###################### Private DNS Zone Virtual Network Link#######################

variable "pdz_vnet_link" {
  type = map(object({
    name                  = string
    resource_group_name   = optional(string)
    private_dns_zone_name = string
    virtual_network_name  = string
    tags                  = optional(map(any))
  }))
  default = {}
}

################################## VPN Gateway ################################

variable "vpn_gateway" {
  type = map(object({
    name                             = string
    location                         = optional(string)
    resource_group_name              = optional(string)
    type                             = string
    vpn_type                         = optional(string)
    active_active                    = optional(bool)
    enable_bgp                       = optional(bool)
    sku                              = string
    default_local_network_gateway_id = optional(string)
    edge_zone                        = optional(string)
    generation                       = optional(string)
    private_ip_address_enabled       = optional(bool)
    ip_configurations                = map(any)
    vpn_client_configuration         = optional(map(any))
    bgp_settings                     = optional(map(any))
    tags                             = optional(map(any))
  }))
  default = {}
}

################################## Gateway Connections ################################

variable "gw_connection" {
  type = map(object({
    name                       = string
    location                   = optional(string)
    resource_group_name        = optional(string)
    tags                       = optional(map(any))
    type                       = string
    virtual_network_gateway_id = string
    local_network_gateway_id   = optional(string)
    shared_key                 = optional(string)
    connection_protocol        = optional(string)
    ipsec_policy               = optional(map(any))
  }))
  default = {}
}

################################## Local Network Gateway ################################

variable "ln_gateway" {
  type = map(object({
    name                = string
    location            = optional(string)
    resource_group_name = optional(string)
    gateway_address     = optional(string)
    gateway_fqdn        = optional(string)
    address_space       = optional(list(string))
    tags                = optional(map(any))
  }))
  default = {}
}

###################### FIREWALL ###########################
variable "firewall" {
  type = map(object({
    name                 = string
    location             = optional(string)
    resource_group_name  = optional(string)
    sku_name             = optional(string)
    sku_tier             = optional(string)
    zones                = optional(list(string))
    ip_config            = optional(map(any))
    firewall_policy_name = optional(string)
    tags                 = optional(map(any))
  }))
  default = {}
}

###################### FIREWALL POLICY ###########################
variable "fw_policy" {
  type = map(object({
    name                              = string
    location                          = optional(string)
    resource_group_name               = optional(string)
    auto_learn_private_ranges_enabled = optional(bool)
    sku                               = optional(string)
    dns                               = optional(map(any))
    tags                              = optional(map(any))
  }))
  default = {}
}

###################### FIREWALL POLICY RULE COLLECTION GROUP ###########################

variable "fw_rule_coll" {
  type = map(object({
    name                = string
    firewall_policy_key = string
    priority            = number
    nat_rule_collection = optional(object({
      name     = string
      action   = string
      priority = number
      rule = map(object({
        name                = string
        description         = optional(string)
        protocols           = optional(list(string))
        destination_ports   = optional(list(string))
        source_addresses    = optional(list(string))
        destination_address = optional(string)
        translated_port     = optional(string)
        translated_address  = optional(string)
      }))
    }))
    network_rule_collection = optional(object({
      name     = string
      action   = string
      priority = number
      rule = map(object({
        name                  = optional(string)
        protocols             = optional(list(string))
        source_addresses      = optional(list(string))
        destination_addresses = optional(list(string))
        destination_ports     = optional(list(string))
        destination_fqdns     = optional(list(string))
      }))
    }))
    application_rule_collection = optional(object({
      name     = string
      action   = string
      priority = number
      rule = map(object({
        name              = optional(string)
        protocols         = optional(map(any))
        source_addresses  = optional(list(string))
        destination_fqdns = optional(list(string))
      }))
    }))
  }))
  default = {}
}

variable "client_config" {
  default = {}
}

variable "data_sources" {
  description = "Data gathering for resources not managed by CAF Module"
  default     = {}
}


variable "frontdoor_profile" {
  type = map(object({
    name                     = string
    resource_group_name      = optional(string)
    sku_name                 = string
    response_timeout_seconds = optional(string)
    tags = optional(map(any), {
      "Application"          = "Cloud"
      "ApplicationOwner"     = "IT_Platforms@onxpress.com"
      "BusinessOwner"        = "ONx"
      "BusinessUnitFunction" = "Infra"
      "CostCenter"           = "O&M"
      "Environment"          = "PROD"
    })
  }))
}

variable "fd_eps" {
  type = map(object({
    name                     = string
    cdn_frontdoor_profile_id = string
    tags = optional(map(any), {
      "Application"          = "Cloud"
      "ApplicationOwner"     = "IT_Platforms@onxpress.com"
      "BusinessOwner"        = "ONx"
      "BusinessUnitFunction" = "Infra"
      "CostCenter"           = "O&M"
      "Environment"          = "PROD"
    })
  }))
}

#############################################  CDN FRONTFOOR #################################################################

variable "fd_ogs" {
  type = map(object({
    name                                                      = string
    cdn_frontdoor_profile_id                                  = string
    session_affinity_enabled                                  = optional(bool, false)
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number, 0)
    health_probe = optional(map(object({
      interval_in_seconds = optional(number, "100")
      path                = optional(string, "/")
      protocol            = optional(string, "Https")
      request_type        = optional(string, "HEAD")
      })), {
      1 = {
        interval_in_seconds = 100
        path                = "/"
        protocol            = "Https"
        request_type        = "HEAD"
      }
    })
    additional_latency_in_milliseconds = optional(number, "50")
    sample_size                        = optional(number, "4")
    successful_samples_required        = optional(number, "3")
  }))
}

variable "fd_origins" {
  type = map(object({
    name                           = string
    cdn_frontdoor_origin_group_id  = string
    is_enabled                     = optional(bool, true)
    certificate_name_check_enabled = optional(bool, false)
    host_name                      = string
    http_port                      = optional(number, 80)
    https_port                     = optional(number, 443)
    origin_host_header             = string
    priority                       = optional(number, 1)
    weight                         = optional(number, 1000)
  }))
}


variable "fd_custom_domains" {
  type = map(object({
    name                     = string
    cdn_frontdoor_profile_id = string
    dns_zone_id              = optional(string)
    host_name                = string
    certificate_type         = optional(string, "ManagedCertificate")
    minimum_tls_version      = optional(string, "TLS12")
  }))
}

variable "fd_routes" {
  type = map(object({
    name                            = string
    cdn_frontdoor_endpoint_id       = string
    cdn_frontdoor_origin_group_id   = string
    cdn_frontdoor_rule_set_ids      = optional(list(string), [])
    cdn_frontdoor_custom_domain_ids = string
    is_route_enabled                = optional(bool, true)
    forwarding_protocol             = optional(string, "HttpsOnly")
    https_redirect_enabled          = optional(bool, true)
    patterns_to_match               = optional(list(string), ["/*"])
    supported_protocols             = optional(list(string), ["Https"])
    link_to_default_domain          = optional(bool, true)
    cache = optional(map(object({
      query_string_caching_behavior = optional(string, "UseQueryString")
      compression_enabled           = optional(bool, true)
      content_types_to_compress     = optional(list(string))
    })))
  }))
}