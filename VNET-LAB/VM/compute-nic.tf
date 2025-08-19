#get the virtual network and subnet
data "azurerm_subnet" "snet1" {
  name                 = "snet1-network-${var.environment_name}"
  virtual_network_name = "vnet-network-${var.environment_name}"
  resource_group_name  = "rg-network-${var.environment_name}"
}

#set up the network interface (NIC)
resource "azurerm_network_interface" "vm1" {
  name                = "nic-${var.application_name}-${var.environment_name}-vm1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = data.azurerm_subnet.snet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm1.id
  }
}