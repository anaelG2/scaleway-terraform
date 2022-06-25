# module "consul" {
#   source  = "./"
#   version = "0.0.5"
# }

resource "local_file" "create-ansible-inventory" {
 content = templatefile("ansible_inventory.tmpl",
 {
  hostnames         = tolist([scaleway_instance_server.webserver-node-1.name,scaleway_instance_server.webserver-node-2.name]),
  ansible_hosts     = tolist([scaleway_instance_server.webserver-node-1.public_ip,scaleway_instance_server.webserver-node-2.public_ip]),
  is_webserver_node = true
  is_python_interpreted = true
 }
 )
 filename = "../hosts"
}


