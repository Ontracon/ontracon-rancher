#
# Creating Resource Group
#
resource "azurerm_resource_group" "MyRG" {
  name     = var.my_default_rg_name
  location = var.location
  tags     = var.tags
}

#
# Generate a Random ID when new RG is created
#

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "azurerm_resource_group.MyRG.name"
  }

  byte_length = 8
}

