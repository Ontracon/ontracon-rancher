
terraform {
  required_version = ">= 0.12"
}

# Azure Provider with Version
provider "azurerm" {
  version = "~>1.36.0"
}

# random ID generator
provider "random" {
  version = "~> 2.2"
}

