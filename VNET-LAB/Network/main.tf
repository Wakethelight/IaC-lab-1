#build resource group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

#network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-network-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.base_address_space]


  tags = {
    environment = "${var.environment_name}"
  }
}

locals {
    bastion_subnet = cidrsubnet(var.base_address_space, 4, 0)
    snet1_subnet = cidrsubnet(var.base_address_space, 2, 1)
    snet2_subnet = cidrsubnet(var.base_address_space, 2, 2)
    snet3_subnet = cidrsubnet(var.base_address_space, 2, 3)
}

#subnets 10.11.0.0/26:

#start at 10.11.0.0
#end at 10.11.0.64
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.bastion_subnet]

} 

#subnet: 10.11.1.0/24
resource "azurerm_subnet" "snet1" {
  name                 = "snet1-${var.application_name}-${var.environment_name}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.snet1_subnet]

}

resource "azurerm_subnet" "snet2" {
  name                 = "snet2-${var.application_name}-${var.environment_name}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.snet2_subnet]

}

/*
#network security group
resource "azurerm_network_security_group" "remote_access" {
  name                = "nsg-${var.application_name}-${var.environment_name}-remote-access"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = chomp(data.http.my_ip.body)
    destination_address_prefix = "*"
  }

  tags = {
    environment = "${var.environment_name}"
  }
}

#network security group association


resource "azurerm_subnet_network_security_group_association" "charlie_remote_access" {
  subnet_id                 = azurerm_subnet.charlie.id
  network_security_group_id = azurerm_network_security_group.remote_access.id
}
resource "azurerm_subnet_network_security_group_association" "delta_remote_access" {
  subnet_id                 = azurerm_subnet.delta.id
  network_security_group_id = azurerm_network_security_group.remote_access.id
}

data "http" "my_ip" {
    url = "https://ifconfig.me/ip"
}
*/

#create bastion host
#resource "azurerm_public_ip" "bastion" {
#  name                = "pip-${var.application_name}-${var.environment_name}-bastion"
#  location            = azurerm_resource_group.main.location
#  resource_group_name = azurerm_resource_group.main.name
#  allocation_method   = "Static"
#  sku                 = "Standard"
#}

#resource "azurerm_bastion_host" "main" {
#  name                = "bas-${var.application_name}-${var.environment_name}"
#  location            = azurerm_resource_group.main.location
#  resource_group_name = azurerm_resource_group.main.name

#  ip_configuration {
#    name                 = "configuration"
#    subnet_id            = azurerm_subnet.bastion.id
#    public_ip_address_id = azurerm_public_ip.bastion.id
#  }
#}
