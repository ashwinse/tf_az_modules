variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "sql_version" {}
variable "administrator_login" {}
variable "administrator_login_password" {}
variable "tags" {
  type = map(any)
}