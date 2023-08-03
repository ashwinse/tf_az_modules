variable "name" {}

variable "location" {}

variable "tags" {
  type = map(any)
}
variable "max_shares" {
  default = null
}
variable "resource_group_name" {}

variable "storage_account_type" {} //Standard_LRS, Premium_LRS, StandardSSD_LRS

variable "create_option" {} // Import, Empty, Copy, FromImage, Restore

/*
Import - Import a VHD file in to the managed disk (VHD specified with source_uri).
Empty - Create an empty managed disk.
Copy - Copy an existing managed disk or snapshot (specified with source_resource_id).
FromImage - Copy a Platform Image (specified with image_reference_id)
Restore - Set by Azure Backup or Site Recovery on a restored disk (specified with source_resource_id).
*/

variable "source_resource_id" {
  default = null
}
variable "image_reference_id" {
  default = null
}
variable "source_uri" {
  default = null
}
variable "disk_size_gb" {
  default = null
}
variable "os_type" {
  default = null // Linux or Windows
}
variable "storage_account_id" {
  default = null
}