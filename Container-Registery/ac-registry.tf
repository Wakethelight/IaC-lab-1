#create container registry
resource "azurerm_container_registry" "main" {
  name                     = "wakeacr${var.application_name}${var.environment_name}"
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  sku                      = "Basic"
  #admin_enabled            = false

  tags = {
    environment = var.environment_name
  }
}