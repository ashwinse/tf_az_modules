
variable "location" {
  description = "location of the resource if different from the resource group."
  default     = null
}
variable "resource_group_name" {
  description = "Resource group object to deploy the virtual machine"
  default     = null
}
variable "validate_environment" {
  description = "Resource group object to deploy the virtual machine"
}
variable "tags" {
  type = map(any)
}
variable "no_of_sessions" {
  type = number
}
variable "prefix" {
}
variable "vm_size" {
}
variable "admin_password" {
}
variable "admin_username" {
}
variable "subnet_id" {
}
variable "type" {
}
variable "source_image_id" {
}
variable "name" {
  default = {}
}
variable "maximum_sessions_allowed" {
  
}
variable "load_balancer_type" {}
variable "personal_desktop_assignment_type" {}
variable "custom_rdp_properties" {}
variable "registration_token" {
  default = null
}