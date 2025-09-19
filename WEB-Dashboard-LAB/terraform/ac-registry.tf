#create container registry
resource "azurerm_container_registry" "main" {
  name                     = "wakeacr${var.environment_name}"
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  sku                      = "basic"
  admin_enabled            = true

  tags = {
    environment = var.environment_name
  }
}