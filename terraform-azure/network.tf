#refer to a subnet
data "azurerm_subnet" "MyNet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}

