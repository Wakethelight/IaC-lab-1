
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}



resource "random_string" "keyvault_suffix" {
    length = 6
    special = false
    upper = false
}



data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "current" {
}

data "azurerm_log_analytics_workspace" "observability" {
  name                = "log-observability-dev"
  resource_group_name = "rg-observability-dev"
}


resource "azurerm_monitor_diagnostic_setting" "main" {
  name               = "diag-${var.application_name}-${var.environment_name}-${random_string.keyvault_suffix.result}"
  target_resource_id = azurerm_key_vault.main.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.observability.id
  enabled_log {
    category_group = "audit"
  }
  enabled_log {
    category_group = "allLogs"
  }
  metric {
    category = "AllMetrics"
  }
}