variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "size" {}           # "Standard_F2"
variable "admin_username" {} # "adminuser"

variable "disable_password_authentication" {
  default = null
}
variable "admin_password" {
  default = null
} # "P@$$w0rd1234!"
variable "ssh_public_key" {
  default = null
}
variable "host_name" {}
variable "availability_set_id" {
  default = null
}
variable "network_interface_ids" {
  type = list(any)
}
variable "os_disk_name" {}
variable "create_option" {}   # "FromImage"
variable "os_disk_caching" {} # "ReadWrite"
variable "vhd_uri" {
  default = null
}
variable "managed_disk_id" {
  default = null
}
variable "os_type" {}              # Linux or Windows
variable "storage_account_type" {} # "Standard_LRS"
variable "disk_size_gb" {}
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
variable "provision_vm_agent" {
  default = null
} # true or false
variable "enable_automatic_upgrades" {
  default = null
} # true or false

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

variable "boot_diagnostics_storage_uri" {
  default = null
}

variable "delete_os_disk_on_termination" {}

variable "delete_data_disks_on_termination" {}

variable "is_data_disk_required" {} # true or false

variable "data_disk_settings" {
  default = null
} # Example below

/* variable "data_disk_settings" {
    default = [
        {
            name              = "datadisk0"
            caching           = "ReadWrite"
            create_option     = "Empty"
            disk_size_gb      = 10
            managed_disk_id   = null
            managed_disk_type = "Standard_LRS"
            vhd_uri           = null
            lun               = 10
        },
        {
            name              = "datadisk1"
            caching           = "ReadWrite"
            create_option     = "Empty"
            disk_size_gb      = 10
            managed_disk_id   = null
            managed_disk_type = "Standard_LRS"
            vhd_uri           = null
            lun               = 11
        }
    ]
} */