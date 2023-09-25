variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "sku" {}
variable "instances" {}
variable "admin_password" {}
variable "admin_username" {}
variable "disable_password_authentication" {
  default = false
}
variable "public_key" {
  default = null
}
variable "automatic_instance_repair_enabled" {
  default = false
}
variable "automatic_instance_repair_grace_period" {
  default = null
}
variable "is_automatic_os_upgrade_policy" {
  default = false
}
variable "disable_automatic_rollback" {
  default = null
}
variable "enable_automatic_os_upgrade" {
  default = null
}
variable "boot_diagnostics_storage_account_uri" {
  default = null
}
variable "capacity_reservation_group_id" {
  default = null
}
variable "computer_name_prefix" {
  default = null
}
variable "custom_data" {
  default = null
}
variable "is_data_disk_required" {
  default = false
}
variable "data_disk_settings" {
  default = null
}
/* variable "data_disk_settings" {
    default = [
        {
            name              = "datadisk0"
            caching           = "ReadWrite"
            create_option     = "Empty"
            disk_size_gb      = 10
            storage_account_type      = "Standard_LRS"
            lun                       = 1
            disk_encryption_set_id    = null
            write_accelerator_enabled = null
        },
        {
            name              = "datadisk1"
            caching           = "ReadWrite"
            create_option     = "Empty"
            disk_size_gb      = 10
            storage_account_type      = "Standard_LRS"
            lun                       = 2
        }
    ]
} */

variable "edge_zone" {
  default = null
}
variable "encryption_at_host_enabled" {
  default = null
}
variable "eviction_policy" {
  default = null
}
variable "is_gallery_application" {
  default = false
}
variable "gallery_application_version_id" {
  default = null
}
variable "gallery_application_configuration_blob_uri" {
  default = null
}
variable "gallery_application_order" {
  default = null
}
variable "health_probe_id" {
  default = null
}
variable "host_group_id" {
  default = null
}
variable "is_identity" {
  default = false
}
variable "identity_type" {
  default = null
}
variable "identity_ids" {
  default = null
}
variable "overprovision" {
  default = null
}
variable "is_image_from_marketplace" {
  default = false
}
variable "plan_name" {
  default = null
}
variable "plan_publisher" {
  default = null
}
variable "plan_product" {
  default = null
}

variable "platform_fault_domain_count" {
  default = null
}
variable "priority" {
  default = null
}
variable "provision_vm_agent" {
  default = null
}
variable "proximity_placement_group_id" {
  default = null
}
variable "is_rolling_upgrade_policy" {
  default = false
}
variable "max_batch_instance_percent" {
  default = null
}
variable "max_unhealthy_instance_percent" {
  default = null
}
variable "max_unhealthy_upgraded_instance_percent" {
  default = null
}
variable "pause_time_between_batches" {
  default = null
}
variable "is_scale_in" {
  default = false
}
variable "scale_in_rule" {
  default = null
}
variable "scale_in_force_deletion_enabled" {
  default = null
}
variable "secure_boot_enabled" {
  default = null
}
variable "single_placement_group" {
  default = null
}
variable "source_image_id" {
  default = null
}
variable "content_publisher" {
  default = null
}
variable "content_offer" {
  default = null
}
variable "content_sku" {
  default = null
}
variable "content_version" {
  default = null
}
variable "spot_restore_enabled" {
  default = false
}
variable "spot_restore_timeout" {
  default = null
}
variable "termination_notification_enabled" {
  default = false
}
variable "termination_notification_timeout" {
  default = null
}
variable "upgrade_mode" {
  default = null
}
variable "user_data" {
  default = null
}
variable "vtpm_enabled" {
  default = null
}
variable "zone_balance" {
  default = null
}
variable "zones" {
  default = null
}
variable "os_disk_caching" {}
variable "storage_account_type" {}
variable "disk_size_gb" {
  default = null
}
variable "write_accelerator_enabled" {
  default = null
}
variable "security_encryption_type" {
  default = null
}
variable "disk_encryption_set_id" {
  default = null
}
variable "secure_vm_disk_encryption_set_id" {
  default = null
}
variable "network_interface_name" {}
variable "dns_servers" {
  default = null
}
variable "enable_accelerated_networking" {
  default = null
}
variable "enable_ip_forwarding" {
  default = null
}
variable "network_security_group_id" {
  default = null
}
variable "subnet_id" {
  default = null
}
variable "application_gateway_backend_address_pool_ids" {
  default = null
}
variable "application_security_group_ids" {
  default = null
}
variable "load_balancer_backend_address_pool_ids" {
  default = null
}
variable "load_balancer_inbound_nat_rules_ids" {
  default = null
}
variable "ip_configuration_version" {
  default = "IPv4"
}
variable "is_public_ip_address" {
  default = false
}
variable "public_ip_address_name" {
  default = null
}
variable "public_ip_address_domain_name_label" {
  default = null
}
variable "public_ip_address_idle_timeout_in_minutes" {
  default = null
}
variable "is_additional_nic_required" {
  default = null
}
variable "additional_nic_settings" {
  default = null
}
variable "subnet_info" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
  }))
  default = null
}
/*
variable "additional_nic_settings" {
  default = [
        {
            name                                         = ""
            dns_servers                                  = ""
            primary                                      = false
            enable_accelerated_networking                = ""
            enable_ip_forwarding                         = ""
            network_security_group_id                    = ""
            subnet_id                                    = ""
            application_gateway_backend_address_pool_ids = [""]
            application_security_group_ids               = [""]
            load_balancer_backend_address_pool_ids       = [""]
            load_balancer_inbound_nat_rules_ids          = [""]
            version                                      = "IPv4"
            ip_configuration_name                        = ""
            is_public_ip_address                         = true
            public_ip_address_name                       = ""
            public_ip_address_domain_name_label          = null
            public_ip_address_idle_timeout_in_minutes    = null
        },
        {
            name                                         = ""
            subnet_id                                    = ""
            application_gateway_backend_address_pool_ids = [""]
            application_security_group_ids               = [""]
            load_balancer_backend_address_pool_ids       = [""]
            load_balancer_inbound_nat_rules_ids          = [""]
            is_public_ip_address                         = false
        }
    ]
}
*/
variable "tags" {
  default = null
}
