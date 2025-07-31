locals {
  is_hns_enabled                    = (var.account_kind == "BlockBlobStorage" ? var.is_hns_enabled : null)
  nfsv3_enabled                     = ((var.account_tier == "Standard" && var.account_kind == "StorageV2") || (var.account_tier == "Premium" && var.account_kind == "BlockBlobStorage") ? var.nfsv3_enabled : null)
  queue_encryption_key_type         = (var.account_kind == "StorageV2" ? "Account" : "Service")
  table_encryption_key_type         = (var.account_kind == "StorageV2" ? "Account" : "Service")
  infrastructure_encryption_enabled = (var.account_kind == "StorageV2" || (var.account_tier == "Premium" && (var.account_kind == "BlockBlobStorage" || var.account_kind == "FileStorage")) ? var.infrastructure_encryption_enabled : null)
  sftp_enabled                      = (var.is_hns_enabled == true ? var.sftp_enabled : null)
}

resource "azurerm_storage_account" "sa" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier
  # enable_https_traffic_only         = var.enable_https_traffic_only
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  min_tls_version                   = var.min_tls_version
  tags                              = var.tags
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  shared_access_key_enabled         = var.shared_access_key_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  is_hns_enabled                    = local.is_hns_enabled
  nfsv3_enabled                     = local.nfsv3_enabled
  large_file_share_enabled          = var.large_file_share_enabled
  queue_encryption_key_type         = local.queue_encryption_key_type
  table_encryption_key_type         = local.table_encryption_key_type
  infrastructure_encryption_enabled = local.infrastructure_encryption_enabled
  allowed_copy_scope                = var.allowed_copy_scope
  sftp_enabled                      = local.sftp_enabled ## is true only when is_hns_enabled is true
  dynamic "azure_files_authentication" {
    for_each = try(var.azure_files_authentication, null) != null ? var.azure_files_authentication : {}
    content {
      directory_type = var.azure_files_authentication.directory_type
      dynamic "active_directory" {
        for_each = try(var.azure_files_authentication.active_directory, null) != null ? var.azure_files_authentication.active_directory : {}
        content {
          storage_sid         = var.azure_files_authentication.active_directory.storage_sid
          domain_name         = var.azure_files_authentication.active_directory.domain_name
          domain_guid         = var.azure_files_authentication.active_directory.domain_guid
          domain_sid          = var.azure_files_authentication.active_directory.domain_sid
          forest_name         = var.azure_files_authentication.active_directory.forest_name
          netbios_domain_name = var.azure_files_authentication.active_directory.netbios_domain_name
        }
      }
    }
  }
  dynamic "immutability_policy" {
    for_each = var.is_immutability_policy_req == true ? [1] : []
    content {
      allow_protected_append_writes = var.allow_protected_append_writes
      state                         = var.immutability_policy_state
      period_since_creation_in_days = var.period_since_creation_in_days
    }
  }
  dynamic "sas_policy" {
    for_each = var.is_sas_policy_req == true ? [1] : []
    content {
      expiration_period = var.sas_policy_expiration_period ## DD.HH:MM:SS
      expiration_action = var.sas_policy_expiration_action
    }
  }
  dynamic "static_website" {
    for_each = var.is_static_website_req == true && var.account_kind == "StorageV2" || var.account_kind == "BlockBlobStorage" ? [1] : []
    content {
      index_document     = var.index_document
      error_404_document = var.error_404_document
    }
  }
  dynamic "custom_domain" {
    for_each = var.is_custom_domain_req == true ? [1] : []
    content {
      name          = var.custom_domain_name
      use_subdomain = var.custom_domain_use_subdomain
    }
  }
  dynamic "customer_managed_key" {
    for_each = var.is_customer_managed_key_req == true ? [1] : []
    content {
      key_vault_key_id          = var.key_vault_key_id
      user_assigned_identity_id = var.user_assigned_identity_id
    }
  }
  dynamic "blob_properties" {
    for_each = try(var.configurations.blob_properties, null) != null ? var.configurations.blob_properties : {}
    content {
      versioning_enabled            = try(blob_properties.value.versioning_enabled, null)
      change_feed_enabled           = try(blob_properties.value.change_feed_enabled, null)
      change_feed_retention_in_days = try(blob_properties.value.change_feed_retention_in_days, null)
      last_access_time_enabled      = try(blob_properties.value.last_access_time_enabled, null)
      default_service_version       = try(blob_properties.value.default_service_version, null)
      dynamic "delete_retention_policy" {
        for_each = try(blob_properties.value.delete_retention_policy, null) != null ? [1] : []
        content {
          days = blob_properties.value.delete_retention_policy.days
          # permanent_delete_enabled = try(blob_properties.value.delete_retention_policy.permanent_delete_enabled, null)
        }
      }
      dynamic "restore_policy" {
        for_each = try(blob_properties.value.restore_policy, null) != null ? [1] : []
        content {
          days = blob_properties.value.restore_policy.days
        }
      }
      dynamic "container_delete_retention_policy" {
        for_each = try(blob_properties.value.container_delete_retention_policy, null) != null ? [1] : []
        content {
          days = blob_properties.value.container_delete_retention_policy.days
        }
      }
      dynamic "cors_rule" {
        for_each = try(blob_properties.value.cors_rule, null) != null ? [1] : []
        content {
          allowed_headers    = blob_properties.value.cors_rule.allowed_headers
          allowed_methods    = blob_properties.value.cors_rule.allowed_methods
          allowed_origins    = blob_properties.value.cors_rule.allowed_origins
          exposed_headers    = blob_properties.value.cors_rule.exposed_headers
          max_age_in_seconds = blob_properties.value.cors_rule.max_age_in_seconds
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = var.is_queue_properties_req == true ? [1] : []
    content {
      dynamic "cors_rule" {
        for_each = var.is_cors_rule_req_queue == true ? [1] : []
        content {
          allowed_headers    = var.allowed_headers
          allowed_methods    = var.allowed_methods
          allowed_origins    = var.allowed_origins
          exposed_headers    = var.exposed_headers
          max_age_in_seconds = var.max_age_in_seconds
        }
      }
      dynamic "logging" {
        for_each = var.is_logging_req == true ? [1] : []
        content {
          delete                = var.logging_delete
          read                  = var.logging_read
          version               = var.logging_version
          write                 = var.write
          retention_policy_days = var.retention_policy_days
        }
      }

    }
  }
  dynamic "share_properties" {
    for_each = var.is_share_properties_req == true ? [1] : []
    content {
      dynamic "cors_rule" {
        for_each = var.is_cors_rule_req_share == true ? [1] : []
        content {
          allowed_headers    = var.allowed_headers
          allowed_methods    = var.allowed_methods
          allowed_origins    = var.allowed_origins
          exposed_headers    = var.exposed_headers
          max_age_in_seconds = var.max_age_in_seconds
        }
      }
      dynamic "retention_policy" {
        for_each = var.is_share_retention_policy_req == true ? [1] : []
        content {
          days = var.share_retention_policy_days
        }
      }
      dynamic "smb" {
        for_each = var.is_smb_req == true ? [1] : []
        content {
          versions                        = var.smb_version
          authentication_types            = var.authentication_types
          kerberos_ticket_encryption_type = var.kerberos_ticket_encryption_type
          channel_encryption_type         = var.channel_encryption_type
          multichannel_enabled            = var.multichannel_enabled
        }
      }

    }
  }

  dynamic "identity" {
    for_each = var.is_identity_req == true ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }
  dynamic "network_rules" {
    for_each = try(var.network_rules, null) != null ? var.network_rules : {}
    content {
      default_action             = network_rules.value.default_action
      bypass                     = try(network_rules.value.bypass, [])
      ip_rules                   = try(network_rules.value.ip_rules, null)
      virtual_network_subnet_ids = try(network_rules.value.virtual_network_subnet_ids, null)
      dynamic "private_link_access" {
        for_each = try(network_rules.value.private_link_access, null) != null ? network_rules.value.private_link_access : {}
        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = try(private_link_access.value.endpoint_tenant_id, null)
        }
      }
    }
  }

}
