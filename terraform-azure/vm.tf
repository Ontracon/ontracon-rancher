#
# Create Storage Account for diagnostic of VM's
#
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "ondiag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.MyRG.name
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
  tags                     = var.tags
}

#
# Create Availibility SET
#
resource "azurerm_availability_set" "avset" {
  name                         = "avset-rancher"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.MyRG.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

# Create Network Interfaces and assign public IP
#
resource "azurerm_network_interface" "vm_nics" {
  name                = "NIC-${var.vm_names[count.index]}"
  location            = var.location
  resource_group_name = azurerm_resource_group.MyRG.name

  ip_configuration {
    name                                    = "myNicConfiguration"
    subnet_id                               = data.azurerm_subnet.MyNet.id
    private_ip_address_allocation           = "dynamic"
#    load_balancer_backend_address_pools_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
  }
  tags  = var.tags
  count = length(var.vm_names)
}


#
# Create VM's
#

resource "azurerm_virtual_machine" "vms" {
  name                  = var.vm_names[count.index]
  location              = var.location
  resource_group_name   = azurerm_resource_group.MyRG.name
  network_interface_ids = [element(azurerm_network_interface.vm_nics.*.id, count.index)]
  vm_size               = var.vm_size
  availability_set_id   = azurerm_availability_set.avset.id

  #VIP as it removes orphaned VHDs
  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = "OsDisk-${var.vm_names[count.index]}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "openlogic"
    offer     = "CentOS"
    sku       = "7.7"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.vm_names[count.index]
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = var.ssh_path
      key_data = var.ssh_key
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
  count = length(var.vm_names)

# Wait until Instance is up
  provisioner "remote-exec" {
    connection {
      host        = element(azurerm_network_interface.vm_nics.*.private_ip_address, count.index)    # TF-UPGRADE-TODO: Set this to the IP address of the machine's primary network interface
      type        = "ssh" # TF-UPGRADE-TODO: If this is a windows instance without an SSH server, change to "winrm"
      user        = var.admin_username
      private_key = file("~/.ssh/id_rsa")
    }

    inline = [
      "echo 'Hello World'",
    ]
  }


}

 
 
