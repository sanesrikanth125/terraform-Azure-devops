provider "azurerm" {

  subscription_id = var.subscription-id
  client_id       = var.client-id
  client_secret   = var.client-secret
  tenant_id       = var.tenant-id
  features {}
}
data "azurerm_resource_group" "RG"{
    name = "myResourceGroup"
}
resource "azurerm_managed_disk" "disk-data" {
  name                 = "sri-datadisk"
  location             = "West US 2"
  resource_group_name  = data.azurerm_resource_group.RG.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "2"

  tags = {
    environment = "staging"
  }
}
