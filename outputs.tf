### Création et mise à jour de l'inventaire hosts
resource "local_file" "ansible-inventory" {
  count = var.instance_count
  content = templatefile("./files/ansible_inventory.tmpl", {
    hostnames     = "${scaleway_instance_server.nodes.*.name}"
    ansible_hosts = "${scaleway_instance_server.nodes.*.public_ip}"
    }
  )
  filename   = "./hosts"
  depends_on = [scaleway_instance_server.nodes]
}

