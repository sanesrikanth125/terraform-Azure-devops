provider "azurerm" {

  subscription_id = var.subscription-id
  client_id       = var.client-id
  client_secret   = var.client-secret
  tenant_id       = var.tenant-id
  features {}
}
resource "azurerm_resource_group" "myterraformgroup" {
  name     = var.azurerm-RG
  location = var.location
}

resource "azurerm_virtual_network" "Vnet" {
  name                = var.Vnet
  address_space       = var.ip-address
  location            = var.location
  resource_group_name = var.azurerm-RG
}
resource "azurerm_subnet" "Subnet-Vm" {
  name                 = var.Subnet-Vm
  resource_group_name  = var.azurerm-RG
  virtual_network_name = var.Vnet
  address_prefixes     = var.subnet-ip
}
resource "azurerm_network_interface" "Nic-Vnet" {
  name                = var.Nic-Vnet
  location            = var.location
  resource_group_name = var.azurerm-RG

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.Subnet-Vm.id
    private_ip_address_allocation = var.private_ip_address
  }
}
resource "azurerm_virtual_machine" "Vm-main" {
  name                  = "Vm-1"
  location              = var.location
  resource_group_name   = var.azurerm-RG
  network_interface_ids = [azurerm_network_interface.Nic-Vnet.id]
  vm_size               = var.vmSize

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
    computer_name  = var.host-name
    admin_username = var.username
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
