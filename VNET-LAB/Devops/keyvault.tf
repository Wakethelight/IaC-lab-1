resource "random_string" "keyvault_suffix" {
    length = 6
    special = false
    upper = false
}



data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "current" {
}



resource "azurerm_key_vault" "main" {
  name                      = "kv-${var.application_name}-${var.environment_name}-${random_string.keyvault_suffix.result}"
  location                  = azurerm_resource_group.main.location
  resource_group_name       = azurerm_resource_group.main.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true

}

resource "azurerm_role_assignment" "terraform_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}