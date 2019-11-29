# Terraform Backend Configuration
#
# Needs to run with additional Configuration on Init: 
# terraform init -backend-config="access_key=Storage Access Key"
#

# Backend Configuration (Make sure Storage Account & Container does exists
# Skip (comment out) if using local tfstate file

terraform {
  backend "azurerm" {
    storage_account_name = "onprdterraform001"
    container_name       = "on-prd-rancher-tfstate"
    resource_group_name  = "on-ams-prd-default-rg"
    key                  = "terraform.tfstate"
  }
}

