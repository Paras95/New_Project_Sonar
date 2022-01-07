terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.31.0"
    }
  }
}


provider "azurerm" {
  features {}
  
  subscription_id = "0da1eade-1523-4ed2-9b1b-bd852ef87c59" 
  client_id       = "ad82367d-45c4-4f59-8ef2-c13049daf2c8"
  client_secret   = "VObYgVSYUEcBtO~i9f_g_h1gUK8Agl~o42"
  tenant_id       = "4d42b778-eafa-49b8-9531-a8b86e100d87"
}

variable "prefix" {
  default = "sl"
}

resource "azurerm_resource_group" "res_grp_RG" {
  name     = "${var.prefix}-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.res_grp_RG.location
  resource_group_name = azurerm_resource_group.res_grp_RG.name
}

resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.res_grp_RG.name
  location            = azurerm_resource_group.res_grp_RG.location
  allocation_method   = "Static"

}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.res_grp_RG.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.res_grp_RG.location
  resource_group_name = azurerm_resource_group.res_grp_RG.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.res_grp_RG.location
  resource_group_name   = azurerm_resource_group.res_grp_RG.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
    custom_data    = file("./test.sh")
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
    Owner = "Paras"
  }
}
