variable "subscription_id" {}
# variable "client_id" {}
# variable "client_secret" {}
variable "tenant_id" {}
variable "location" {}
// variable "object_id" {}
variable "prefix" {}
variable "ssh_public_key" {
  default = null
}
variable "tags" {
  type    = map(any)
  default = { "Environment" = "test", "Agent" = "tf", "Owner" = "Ashwin" }
}