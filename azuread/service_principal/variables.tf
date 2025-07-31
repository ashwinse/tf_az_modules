variable "app_role_assignment_required" {
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "application_id" {
  description = "Application ID of the service principal to create."
}
variable "azuread_api_permissions" {
  default = {}
}

variable "owners" {
  default = {}
}

