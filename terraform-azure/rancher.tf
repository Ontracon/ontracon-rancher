# Deploy rancher with local script (need helm installed local)

resource "null_resource" "cmd_rancher" {
  depends_on = [
                azurerm_virtual_machine.vms,
                null_resource.cmd_ansible,
                rke_cluster.cluster,
		local_file.kube_cluster_yaml
                ]
  provisioner "local-exec" {
    command = "./rancher-deploy.sh"
  }
}
