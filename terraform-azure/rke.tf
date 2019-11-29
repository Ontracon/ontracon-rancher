
resource rke_cluster "cluster" {
  depends_on = [
	null_resource.cmd_ansible,
        azurerm_virtual_machine.vms
	]

  dynamic nodes {
    for_each = azurerm_network_interface.vm_nics
    content {
      address = azurerm_network_interface.vm_nics[nodes.key].private_ip_address
      user    = var.admin_username
      role    = ["controlplane", "etcd", "worker"]
      ssh_key = file("~/.ssh/id_rsa")
    }
  }
cluster_name = "rancher-management"
}

###############################################################################
# If you need kubeconfig.yml for using kubectl, please uncomment follows.
###############################################################################
resource "local_file" "kube_cluster_yaml" {
  filename = format("%s/%s" , path.root, "kube_config_cluster.yml")
  content = rke_cluster.cluster.kube_config_yaml
}

