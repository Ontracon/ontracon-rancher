### Location for all ressources
variable "location" {
  description = "The location/region where the Application will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default     = "westeurope"
}

### Define tags for all ressources
variable "tags" {
  description = "The tags to associate with the resources."
  type        = map(string)

  default = {
    owner = "j.kritzen@ontracon.de"
    env   = "Production"
  }
}

### Ressource Groups
# Default RG
variable "my_default_rg_name" {
  description = "Default resource group name that the application will be created in."
  default     = "on-ams-prd-rancher-rg"
}

# Existing Network Config
variable "vnet_rg_name" {
  description = "Name of the vnet to use"
  default     = "on-ams-prd-central-net-rg"
}

variable "vnet_name" {
  description = "Name of the vnet to use"
  default     = "on-ams-prd-central-hub"
}

variable "subnet_name" {
  description = "Name of the subnet to use"
  default     = "IaasSubnet"
}

### VM's to create
variable "vm_names" {
  description = "A list of VM's to be deployed."
  default     = ["on-ams-rancher-p01", "on-ams-rancher-p02", "on-ams-rancher-p03"]
}

### User creation
variable "admin_username" {
  description = "The Admin User for the VM's"
  default     = "jkritzen"
}

variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0j9UAe85Gs5Qq0lepbxKDCFZKBuhS3TPa/ycQ27UcbC8iRl5kGXh/cU7e17eeu2qoLdcC5InMD2hodmopV92G6vwjGSoq596khgarHsKV+8sna/2XVW+EFkTSHs648iuUozlaCZQUh9ghfGsExxsqp+ZPW71gt9eqBRD/KwDyJv/g4UISDQEgwY7QGOiDF7SIcPlhYWrUST+55d/GLClTWXnmt43bWAPJuRDWq//z97O/gRAeRGsV034NuMwNzw2LcIIws12VYEsLT3Q3jqWcP8lfHHlmud9MdXb6jZjxRUmO8CW23vVndQxj5riLa5nBPCUKjNYCTYJiXXxZtW/5 jkritzen"
}

variable "ssh_path" {
  default = "/home/jkritzen/.ssh/authorized_keys"
}

variable "vm_size" {
  description = "Size of VM's to be deployed."
  default     = "Standard_B2s"
}

