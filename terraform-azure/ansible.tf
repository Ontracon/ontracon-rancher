#
# Get FQDN Data from VM's
#
data "template_file" "inventory" {
  template = file("templates/inventory.tpl")

  depends_on = [
    azurerm_virtual_machine.vms,
    azurerm_network_interface.vm_nics,
  ]

  vars = {
    # Using Public FQDN Name for ansible
    # Loop trough "azurerm_public_ip" Names
    #web = join("\n", azurerm_public_ip.pip_vms.*.fqdn)
    # Using private IP Adress for ansible
    server = "${join("\n", azurerm_network_interface.vm_nics.*.private_ip_address)}"
  }
  
}

#
# Create Inventory & execute Ansible
#
resource "null_resource" "cmd_ansible" {
  triggers = {
    template_rendered = data.template_file.inventory.rendered
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ../ansible/inventory && ansible-playbook -i ../ansible/inventory ../ansible/site.yml"
  }
}


