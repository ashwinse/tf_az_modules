variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "size" {}           # "Standard_F2"
variable "admin_username" {} # "adminuser"
variable "admin_password" {} # "P@$$w0rd1234!"
variable "host_name" {}
variable "is_plan_exists" {
  default = null
  type    = bool
}
variable "enable_automatic_updates" {
  default = null
}
variable "edge_zone" {
  default = null
}
variable "encryption_at_host_enabled" {
  default = null
}
variable "hotpatching_enabled" {
  default = null
} # true or false Default is false
variable "priority" {
  default = null
}
variable "zone" {
  default = null
}
variable "user_data" {
  default = null
}
variable "timezone" {
  default = null
} # Eastern Standard Time
variable "patch_mode" {
  default = null
} # Manual, AutomaticByOS and AutomaticByPlatform
variable "patch_assessment_mode" {
  default = null
}
variable "availability_set_id" {
  default = null
}
variable "network_interface_ids" {
  type = list(any)
}
variable "custom_data" {
  default = null
}
variable "os_disk_name" {
  default = null
}
variable "os_disk_caching" {}      # "ReadWrite"
variable "storage_account_type" {} # "Standard_LRS"
variable "disk_size_gb" {
  default = null
}
variable "source_image_id" {
  default = null
}
variable "provision_vm_agent" {
  default = null
}
variable "content_publisher" {
  default = null
} # "MicrosoftWindowsServer"
variable "content_offer" {
  default = null
} # "WindowsServer"
variable "content_sku" {
  default = null
} # "2016-Datacenter"
variable "content_version" {
  default = null
} # "latest"

variable "tags" {
  default = null
}
variable "is_image_from_marketplace" {
  default = false
} # true or false

variable "plan_name" {
  default = null
}
variable "plan_publisher" {
  default = null
}
variable "plan_product" {
  default = null
}
variable "is_boot_diagnostics_required" {
  default = false
}
variable "storage_uri" {
  default = null
}

variable "is_identity_required" {
  default = null
  type    = bool
}

variable "msi_type" {
  default = null # 'SystemAssigned', 'UserAssigned', 'SystemAssigned, UserAssigned'
}

variable "identity_ids" {
  default = null
  type    = list(string)
}