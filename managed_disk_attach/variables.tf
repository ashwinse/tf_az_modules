variable "managed_disk_id" {}
variable "virtual_machine_id" {}
variable "lun" {}
variable "caching" {}
variable "create_option" {
  default = null
}
variable "write_accelerator_enabled" {
  default = null
}