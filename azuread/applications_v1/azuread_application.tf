resource "azuread_application" "app" {

  display_name = var.display_name
  owners = concat(
    try(var.owners, []),
    [
      var.client_config.object_id
    ]
  )

}