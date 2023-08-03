variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "size" {}           # "Standard_F2"
variable "admin_username" {} # "adminuser"
variable "user_data" {
  default = null
}
variable "encryption_at_host_enabled" {
  default = null
}
variable "disable_password_authentication" {
  default = null
}
variable "priority" {
  default = null
}
variable "patch_assessment_mode" {
  default = null
}
variable "patch_mode" {
  default = null
}
variable "custom_data" {
  default = null
}
variable "edge_zone" {
  default = null
}
variable "zone" {
  default = null
}
variable "admin_password" {
  default = null
} # "P@$$w0rd1234!"
variable "public_key" {
  default = null
}
variable "host_name" {}
variable "provision_vm_agent" {
  default = null
}
variable "availability_set_id" {
  default = null
}
variable "network_interface_ids" {
  type = list(any)
}
variable "os_disk_caching" {}      # "ReadWrite"
variable "storage_account_type" {} # "Standard_LRS"
variable "disk_size_gb" {
  default = null
}
variable "source_image_id" {
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
  type = map(any)
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

variable "storage_account_uri" {
  default = null
}