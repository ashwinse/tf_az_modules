variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "sku" {} # Basic, Standard, Premium
variable "admin_enabled" {}

variable "is_georeplications_required" {
  type = bool
}
variable "tags" {
  type = map(any)
}
variable "georeplications_settings" {
  default = null
} # Example below

/* variable "georeplications_settings" {
    default = [
        {
            location                = canadacentral
            zone_redundancy_enabled = true
            tags                    = { "Environment" = "test", "Agent" = "tf", "Owner" = "Ashwin" }
        },
        {
            location                = canadaeast
            zone_redundancy_enabled = true
            tags                    = { "Environment" = "test", "Agent" = "tf", "Owner" = "Ashwin" }
        }
    ]
} */