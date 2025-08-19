#make the ssh key
resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#move ssh key to keyvault as secret
data "azurerm_key_vault" "main" {
  name                = "kv-devops-dev-dgzc10"
  resource_group_name = "rg-devops-dev"
}
resource "azurerm_key_vault_secret" "vm1-private" {
  name         = "vm1-ssh-private"
  value        = tls_private_key.vm1.private_key_pem
  key_vault_id = data.azurerm_key_vault.main.id
}
resource "azurerm_key_vault_secret" "vm1-public" {
  name         = "vm1-ssh-public"
  value        = tls_private_key.vm1.public_key_openssh
  key_vault_id = data.azurerm_key_vault.main.id
}