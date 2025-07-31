
variable "location" {
  description = "location of the resource if different from the resource group."
  default     = null
}
variable "resource_group_name" {
  description = "Resource group object to deploy the virtual machine"
  default     = null
}

variable "tags" {
  type = map(any)
}
variable "wvd_host_pools" {
  default = {}
}
variable "name" {
  default = {}
}
variable "host_pool_id" {
  default = {}
}
variable "workspace_id" {
  default = {}
}
variable "type" {
}
