provider "scaleway" {
  alias  = "zone-2-fr"
  zone   = "nl-ams-1"
  region = "nl-ams"
}

resource "scaleway_instance_ip" "public_ip_2" {
  project_id = var.scaleway_project_id
  
}

resource "scaleway_instance_server" "webserver-node-2" {
  project_id        = var.scaleway_project_id
  name              = "webserver-node-2"  
  type              = "DEV1-S"
  image             = "debian_bullseye"
  tags              = ["node", "webserver","projet-annuel"]
  ip_id             = scaleway_instance_ip.public_ip_2.id
  security_group_id = scaleway_instance_security_group.scaleway_security_group.id
  provisioner "local-exec" {
    command = "echo 'test'"
  }
  depends_on = [
    scaleway_lb.loadbalancer, scaleway_instance_security_group.scaleway_security_group , scaleway_instance_ip.public_ip_2
  ]
}

output "webserver-node-2-ip" {
  value = scaleway_instance_server.webserver-node-2.public_ip
}

