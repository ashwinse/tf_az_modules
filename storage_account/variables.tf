variable "name" {}

variable "location" {}

variable "tags" {
  type = map(any)
}
variable "resource_group_name" {}
variable "account_kind" {
  default = null
}                          # BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2
variable "account_tier" {} # Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid
variable "access_tier" {
  default = null
}                                      # Hot and Cool, defaults to Hot
variable "account_replication_type" {} # LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS
variable "enable_https_traffic_only" {
  default = null
} # true or false
variable "cross_tenant_replication_enabled" {
  default = null
}
variable "edge_zone" {
  default = null
}
variable "min_tls_version" {
  default = null
}
variable "allow_nested_items_to_be_public" {
  default = null
}
variable "shared_access_key_enabled" {
  default = null
}
variable "public_network_access_enabled" {
  default = null
}
variable "default_to_oauth_authentication" {
  default = null
}
variable "is_hns_enabled" {
  default = null
}
variable "nfsv3_enabled" {
  default = null
}
variable "large_file_share_enabled" {
  default = null
}
variable "infrastructure_encryption_enabled" {
  default = null
}
variable "allowed_copy_scope" {
  default = null
} # Possible values are AAD and PrivateLink.
variable "sftp_enabled" {
  default = null
} # Possible values are true and false.



variable "is_immutability_policy_req" {
  default = null
}
variable "allow_protected_append_writes" {
  default = null
}
variable "immutability_policy_state" {
  default = null
}
variable "period_since_creation_in_days" {
  default = null
}



variable "is_sas_policy_req" {
  default = null
}
variable "sas_policy_expiration_period" {
  default = null
}
variable "sas_policy_expiration_action" {
  default = null
}



variable "is_static_website_req" {
  default = null
}
variable "index_document" {
  default = null
}
variable "error_404_document" {
  default = null
}



variable "is_custom_domain_req" {
  default = null
}
variable "custom_domain_name" {
  default = null
}
variable "custom_domain_use_subdomain" {
  default = null
}



variable "is_customer_managed_key_req" {
  default = null
}
variable "key_vault_key_id" {
  default = null
}
variable "user_assigned_identity_id" {
  default = null
}



variable "is_blob_properties_req" {
  default = null
}
variable "blob_versioning_enabled" {
  default = null
}
variable "blob_change_feed_enabled" {
  default = null
}
variable "blob_change_feed_retention_in_days" {
  default = null
}
variable "blob_last_access_time_enabled" {
  default = null
}
variable "blob_default_service_version" {
  default = null
}

variable "is_delete_retention_policy_req_blob" {
  default = null
}
variable "delete_retention_policy_days_blob" {
  default = null
}

variable "is_restore_policy_req_blob" {
  default = null
}
variable "restore_policy_days_blob" {
  default = 7
}

variable "is_container_delete_retention_policy_req_blob" {
  default = null
}

variable "container_delete_retention_policy_days_blob" {
  default = null
}

variable "is_cors_rule_req_blob" {
  default = null
}
variable "allowed_headers" {
  default = ["*"]
  type    = list(any)
}
variable "allowed_methods" {
  default = ["GET", "HEAD", "MERGE", "POST", "PUT"]
  type    = list(any)
}
variable "allowed_origins" {
  default = ["*"]
  type    = list(any)
}
variable "exposed_headers" {
  default = ["*"]
  type    = list(any)
}
variable "max_age_in_seconds" {
  default = 120
}

variable "is_queue_properties_req" {
  default = null
}

variable "is_cors_rule_req_queue" {
  default = null
}

variable "is_logging_req" {
  default = null
}
variable "logging_delete" {
  default = "disabled"
}
variable "logging_read" {
  default = "disabled"
}
variable "logging_version" {
  default = "2"
}
variable "write" {
  default = "disabled"
}
variable "retention_policy_days" {
  default = null
}

variable "is_share_properties_req" {
  default = null
}
variable "is_cors_rule_req_share" {
  default = null
}
variable "is_share_retention_policy_req" {
  default = null
}
variable "share_retention_policy_days" {
  default = null
}

variable "is_smb_req" {
  default = null
}
variable "smb_version" {
  default = null
}
variable "authentication_types" {
  default = null
}
variable "kerberos_ticket_encryption_type" {
  default = null
}
variable "channel_encryption_type" {
  default = null
}
variable "multichannel_enabled" {
  default = null
}


variable "is_identity_req" {
  default = null
}
variable "identity_type" {
  default = "SystemAssigned"
}
variable "identity_ids" {
  default = null
  type    = list(any)
}