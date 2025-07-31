variable "name" {
  description = "The name of the backup policy."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "recovery_vault_name" {
  description = "The name of the Recovery Services Vault."
  type        = string
}

variable "policy_type" {
  description = "The type of policy."
  type        = string
  default     = null # V1 or V2
}

variable "timezone" {
  description = "The timezone for the backup policy."
  type        = string
  default     = null # "Eastern Standard Time"
}

variable "instant_restore_retention_days" {
  description = "Number of days for which instant restore points will be retained."
  type        = number
  default     = null # Possible values are between 1 and 5 when policy_type is V1, and 1 to 30 when policy_type is V2. instant_restore_retention_days must be set to 5 if the backup frequency is set to Weekly
}

variable "instant_restore_resource_group" {
  description = "Instant restore resource group configuration."
  type = object({
    prefix = string
    suffix = string
  })
  default = null
}

variable "backup" {
  description = "Backup configuration."
  type = object({
    frequency     = string
    time          = string
    hour_interval = number # Possible values are 4, 6, 8 and 12. This is used when frequency is Hourly.
    hour_duration = number # Possible values are between 4 and 24 This is used when frequency is Hourly. hour_duration must be multiplier of hour_interval
  })
}

variable "retention_daily" {
  description = "Daily retention configuration."
  type = object({
    count = number
  })
  default = null
}

variable "retention_weekly" {
  description = "Weekly retention configuration."
  type = object({
    count    = number
    weekdays = list(string)
  })
  default = null
}

variable "retention_monthly" {
  description = "Monthly retention configuration."
  type = object({
    count    = number
    weekdays = list(string)
    weeks    = list(string)
  })
  default = null
}

variable "retention_yearly" {
  description = "Yearly retention configuration."
  type = object({
    count             = number
    weekdays          = list(string)
    weeks             = list(string)
    months            = list(string)
    days              = list(string)
    include_last_days = bool
  })
  default = null
}

variable "tiering_policy" {
  description = "Tiering policy configuration."
  type = object({
    archived_restore_point = object({
      mode          = string
      duration      = number
      duration_type = string
    })
  })
  default = null
}
