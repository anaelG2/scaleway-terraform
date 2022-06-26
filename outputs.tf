### Création et mise à jour de l'inventaire hosts-zone-1
resource "local_file" "ansible-inventory-zone-1" {
  count = var.instance_count_zone_1
  content = templatefile("./templates/ansible_inventory.tmpl", {
    hostnames     = "${scaleway_instance_server.nodes-zone-1.*.name}"
    ansible_hosts = "${scaleway_instance_server.nodes-zone-1.*.public_ip}"
    }
  )
  filename   = "./hosts-zone-1"
  depends_on = [scaleway_instance_server.nodes-zone-1]
}


### Création et mise à jour de l'inventaire hosts-zone-2
resource "local_file" "ansible-inventory-zone-2" {
  count = var.instance_count_zone_2
  content = templatefile("./templates/ansible_inventory.tmpl", {
    hostnames     = "${scaleway_instance_server.nodes-zone-2.*.name}"
    ansible_hosts = "${scaleway_instance_server.nodes-zone-2.*.public_ip}"
    }
  )
  filename   = "./hosts-zone-2"
  depends_on = [scaleway_instance_server.nodes-zone-2]
}
