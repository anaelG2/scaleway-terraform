# provider "scaleway" {
#   alias  = "zone-1-fr"
#   zone   = var.scaleway_zone_1
#   region = var.scaleway_region_1
# }

# resource "scaleway_instance_ip" "public_ip_1" {
#   project_id = var.scaleway_project_id
  
# }

# resource "scaleway_instance_server" "webserver-node-1" {
#   project_id        = var.scaleway_project_id
#   name              = "webserver-node-1"  
#   type              = "DEV1-S"
#   image             = "debian_bullseye"
#   tags              = ["node", "webserver","projet-annuel"]
#   ip_id             = scaleway_instance_ip.public_ip_1.id
#   security_group_id = scaleway_instance_security_group.scaleway_security_group.id
#   provisioner "local-exec" {
#     command = "ansible all -m ping -i hosts" 
#   }
#   depends_on = [
#     scaleway_lb.loadbalancer, scaleway_instance_security_group.scaleway_security_group , scaleway_instance_ip.public_ip_1, scaleway_object_bucket.website-bucket
#   ]
# }

# output "webserver-node-1-ip" {
#   value = scaleway_instance_server.webserver-node-1.public_ip
# }
