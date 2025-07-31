
resource "azuread_service_principal" "app" {
  application_id               = var.application_id
  app_role_assignment_required = try(var.app_role_assignment_required, false)

  owners = concat(
    try(var.owners, []),
    [
      var.client_config.object_id
    ]
  )

  # lifecycle {
  #   ignore_changes = [application_id]
  # }
}

resource "time_sleep" "propagate_to_azuread" {
  depends_on = [azuread_service_principal.app]

  create_duration = "30s"
}