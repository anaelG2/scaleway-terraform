# provider "scaleway" {
#   alias  = "zone-2-fr"
#   zone   = var.scaleway_zone_2
#   region = var.scaleway_region_2
# }

# resource "scaleway_instance_ip" "public_ip_2" {
#   project_id = var.scaleway_project_id
  
# }

# resource "scaleway_instance_server" "webserver-node-2" {
#   project_id        = var.scaleway_project_id
#   name              = var.webserver_node_name  
#   type              = "DEV1-S"
#   image             = "debian_bullseye"
#   tags              = ["node", "webserver","projet-annuel"]
#   ip_id             = scaleway_instance_ip.public_ip_2.id
#   security_group_id = scaleway_instance_security_group.scaleway_security_group.id
#   provisioner "local-exec" {
#     command = "ansible-playbook --limit ${""} -i ../hosts ../scaleway-playbook-ansible/playbook.yml -v"
#   }
#   depends_on = [
#     scaleway_lb.loadbalancer, scaleway_instance_security_group.scaleway_security_group
#   ]
# }

# output "webserver-node-2-ip" {
#   value = scaleway_instance_server.webserver-node-2.public_ip
# }

