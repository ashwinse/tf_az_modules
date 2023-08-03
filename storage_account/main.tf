locals {
  is_hns_enabled                    = (var.account_kind == "BlockBlobStorage" ? var.is_hns_enabled : null)
  nfsv3_enabled                     = ((var.account_tier == "Standard" && var.account_kind == "StorageV2") || (var.account_tier == "Premium" && var.account_kind == "BlockBlobStorage") ? var.nfsv3_enabled : null)
  queue_encryption_key_type         = (var.account_kind == "StorageV2" ? "Account" : "Service")
  table_encryption_key_type         = (var.account_kind == "StorageV2" ? "Account" : "Service")
  infrastructure_encryption_enabled = (var.account_kind == "StorageV2" || (var.account_tier == "Premium" && (var.account_kind == "BlockBlobStorage" || var.account_kind == "FileStorage")) ? var.infrastructure_encryption_enabled : null)
  sftp_enabled                      = (var.is_hns_enabled == true ? var.sftp_enabled : null)
}

resource "azurerm_storage_account" "sa" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_kind                      = var.account_kind
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  access_tier                       = var.access_tier
  enable_https_traffic_only         = var.enable_https_traffic_only
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
    for_each = var.is_blob_properties_req == true ? [1] : []
    content {
      versioning_enabled            = var.blob_versioning_enabled
      change_feed_enabled           = var.blob_change_feed_enabled
      change_feed_retention_in_days = var.blob_change_feed_retention_in_days
      last_access_time_enabled      = var.blob_last_access_time_enabled
      default_service_version       = var.blob_default_service_version
      dynamic "delete_retention_policy" {
        for_each = var.is_delete_retention_policy_req_blob == true ? [1] : []
        content {
          days = var.delete_retention_policy_days_blob
        }
      }
      dynamic "restore_policy" {
        for_each = var.is_restore_policy_req_blob == true ? [1] : []
        content {
          days = var.restore_policy_days_blob
        }
      }
      dynamic "container_delete_retention_policy" {
        for_each = var.is_container_delete_retention_policy_req_blob == true ? [1] : []
        content {
          days = var.container_delete_retention_policy_days_blob
        }
      }
      dynamic "cors_rule" {
        for_each = var.is_cors_rule_req_blob == true ? [1] : []
        content {
          allowed_headers    = var.allowed_headers
          allowed_methods    = var.allowed_methods
          allowed_origins    = var.allowed_origins
          exposed_headers    = var.exposed_headers
          max_age_in_seconds = var.max_age_in_seconds
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

}
