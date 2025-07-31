module "application_registration" {
  source        = "./azuread/applications_v1"
  for_each      = var.app_registration
  display_name  = each.value.display_name
  owners        = each.value.owners
  client_config = data.azuread_client_config.current
}
module "service_principal" {
  source                       = "./azuread/service_principal"
  for_each                     = var.service_principal
  application_id               = merge(module.application_registration.*...)[each.value.application_key]["application_id"]
  owners                       = each.value.owners
  app_role_assignment_required = each.value.app_role_assignment_required
  tags                         = each.value.tags
  client_config                = data.azuread_client_config.current
}

module "service_principal_password" {
  source                           = "./azuread/service_principal_password"
  for_each                         = var.service_principal_password
  service_principal_id             = merge(module.service_principal.*...)[each.value.service_principal_key]["id"]
  service_principal_application_id = merge(module.application_registration.*...)[each.value.application_key]["application_id"]
  secret_prefix                    = each.value.secret_prefix
  keyvault_name                    = each.value.keyvault_key != null ? merge(module.keyvault.*...)[each.value.keyvault_key]["id"] : null
  client_config                    = data.azuread_client_config.current
}

module "role_assignment" {
  source               = "./role_assignment"
  for_each             = var.role_assignment
  scope                = each.value.scope
  principal_id         = each.value.principal_id_key
  role_definition_name = each.value.builtin_role
}