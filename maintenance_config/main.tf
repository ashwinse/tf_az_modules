resource "azurerm_maintenance_configuration" "mc" {
  name                     = var.configurations.name
  resource_group_name      = try(var.configurations.resource_group_name, var.resource_group_name)
  location                 = try(var.configurations.location, var.location)
  scope                    = var.configurations.scope
  visibility               = try(var.configurations.visibility, var.visibility, null)
  in_guest_user_patch_mode = try(var.configurations.in_guest_user_patch_mode, null)
  tags                     = try(var.configurations.tags, var.tags, {})

  dynamic "window" {
    for_each = length(try(var.configurations.window.start_date_time, "")) > 0 ? [1] : []
    content {
      start_date_time      = try(var.configurations.window.start_date_time, null)
      expiration_date_time = try(var.configurations.window.expiration_date_time, null)
      duration             = try(var.configurations.window.duration, null)
      time_zone            = try(var.configurations.window.time_zone, null)
      recur_every          = try(var.configurations.window.recur_every, null)
    }
  }

  dynamic "install_patches" {
    for_each = length(try(var.configurations.install_patches, "")) > 0 ? [1] : []
    content {
      dynamic "linux" {
        for_each = length(try(var.configurations.install_patches.linux, "")) > 0 ? [1] : []
        content {
          classifications_to_include    = try(var.configurations.install_patches.linux.classifications_to_include, null)
          package_names_mask_to_exclude = try(var.configurations.install_patches.linux.package_names_mask_to_exclude, null)
          package_names_mask_to_include = try(var.configurations.install_patches.linux.package_names_mask_to_include, null)
        }
      }
      dynamic "windows" {
        for_each = length(try(var.configurations.install_patches.windows, "")) > 0 ? [1] : []
        content {
          classifications_to_include = try(var.configurations.install_patches.windows.classifications_to_include, null)
          kb_numbers_to_exclude      = try(var.configurations.install_patches.windows.kb_numbers_to_exclude, null)
          kb_numbers_to_include      = try(var.configurations.install_patches.windows.kb_numbers_to_include, null)
        }
      }
      reboot = try(var.configurations.install_patches.reboot, null)
    }
  }
}
