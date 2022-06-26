### Déclaration du provider Scaleway
terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

### Création du bucket
resource "scaleway_object_bucket" "website-bucket" {
  name = "${var.projet_name}-${var.scaleway_bucket_name}"
  acl  = "public-read"
  tags = {
    key = "websitebucket"
  }
}

### Ajout clé ssh au compte Scaleway
resource "scaleway_account_ssh_key" "main" {
  name       = "main"
  public_key = var.public_ssh_key
  project_id = var.scaleway_project_id
}


### Création de l'adresse ip du loadbalancer et du loadbalancer
resource "scaleway_lb_ip" "loadbalancer-ip" {
  zone       = var.scaleway_zone_1
  project_id = var.scaleway_project_id
}
resource "scaleway_lb" "loadbalancer" {
  ip_id      = scaleway_lb_ip.loadbalancer-ip.id
  zone       = scaleway_lb_ip.loadbalancer-ip.zone
  project_id = var.scaleway_project_id
  name       = "${var.projet_name}-${var.scaleway_loadbalancer_name}"
  type       = "LB-GP-L"
  depends_on = [
    scaleway_lb_ip.loadbalancer-ip
  ]
}


### Création des groupes de sécurité pour les instances des zones 1 et 2
resource "scaleway_instance_security_group" "scaleway_security_group_zone_1" {
  project_id              = var.scaleway_project_id
  zone                    = var.scaleway_zone_1
  name                    = "security-group-${var.scaleway_region_1}"
  inbound_default_policy  = "accept"
  outbound_default_policy = "accept"
}
resource "scaleway_instance_security_group" "scaleway_security_group_zone_2" {
  project_id              = var.scaleway_project_id
  zone                    = var.scaleway_zone_2
  name                    = "security-group-${var.scaleway_region_2}"
  inbound_default_policy  = "accept"
  outbound_default_policy = "accept"
}


### Création des IP et instances
resource "scaleway_instance_ip" "public_ip_zone_1" {
  count      = var.instance_count_zone_1
  project_id = var.scaleway_project_id
  zone       = var.scaleway_zone_1
}
resource "scaleway_instance_server" "nodes-zone-1" {
  count             = var.instance_count_zone_1
  project_id        = var.scaleway_project_id
  zone              = var.scaleway_zone_1
  name              = "${var.projet_name}-${var.webserver_node_name}-${var.scaleway_region_1}-${count.index + 1}"
  type              = var.instance_type
  image             = "debian_bullseye"
  tags              = ["node", "webserver", "projet-annuel"]
  ip_id             = "${scaleway_instance_ip.public_ip_zone_1[count.index].id}"
  security_group_id = scaleway_instance_security_group.scaleway_security_group_zone_1.id
  depends_on = [
    scaleway_lb.loadbalancer,
    scaleway_instance_security_group.scaleway_security_group_zone_1,
    scaleway_instance_ip.public_ip_zone_1,
    scaleway_object_bucket.website-bucket
  ]
}


### Création des IP et instances
resource "scaleway_instance_ip" "public_ip_zone_2" {
  count      = var.instance_count_zone_2
  project_id = var.scaleway_project_id
  zone       = var.scaleway_zone_2
}
resource "scaleway_instance_server" "nodes-zone-2" {
  count             = var.instance_count_zone_2
  project_id        = var.scaleway_project_id
  zone              = var.scaleway_zone_2
  name              = "${var.projet_name}-${var.webserver_node_name}-${var.scaleway_region_2}-${count.index + 1}"
  type              = var.instance_type
  image             = "debian_bullseye"
  tags              = ["node", "webserver", "projet-annuel"]
  ip_id             = "${scaleway_instance_ip.public_ip_zone_2[count.index].id}"
  security_group_id = scaleway_instance_security_group.scaleway_security_group_zone_2.id
  depends_on = [
    scaleway_lb.loadbalancer,
    scaleway_instance_security_group.scaleway_security_group_zone_2,
    scaleway_instance_ip.public_ip_zone_2,
    scaleway_object_bucket.website-bucket,
  ]
}


### Création des frontends pour les zones 1 et 2
resource "scaleway_lb_frontend" "frontend-zone-1" {
  count        = var.instance_count_zone_1
  lb_id        = scaleway_lb.loadbalancer.id
  backend_id   = "${scaleway_lb_backend.backend-zone-1[count.index].id}"
  name         = "${var.projet_name}-zone-1-frontend-${count.index + 1}"
  inbound_port = 80
  depends_on   = [scaleway_lb.loadbalancer, scaleway_instance_server.nodes-zone-1]
}
resource "scaleway_lb_frontend" "frontend-zone-2" {
  count        = var.instance_count_zone_2
  lb_id        = scaleway_lb.loadbalancer.id
  backend_id   = "${scaleway_lb_backend.backend-zone-2[count.index].id}"
  name         = "${var.projet_name}-zone-2-frontend-${count.index + 1}"
  inbound_port = 80
  depends_on   = [scaleway_lb.loadbalancer, scaleway_instance_server.nodes-zone-2]
}


### Création des backends pour les zones 1 et 2
resource "scaleway_lb_backend" "backend-zone-1" {
  count            = var.instance_count_zone_1
  lb_id            = scaleway_lb.loadbalancer.id
  name             = "${var.projet_name}-zone-1-backend-${count.index + 1}"
  forward_protocol = "tcp"
  forward_port     = 80
  proxy_protocol   = "none"
  server_ips       = "${scaleway_instance_server.nodes-zone-1.*.public_ip}"
  depends_on       = [scaleway_lb.loadbalancer, scaleway_instance_server.nodes-zone-1]
}
resource "scaleway_lb_backend" "backend-zone-2" {
  count            = var.instance_count_zone_2
  lb_id            = scaleway_lb.loadbalancer.id
  name             = "${var.projet_name}-zone-1-backend-${count.index + 1}"
  forward_protocol = "tcp"
  forward_port     = 80
  proxy_protocol   = "none"
  server_ips       = "${scaleway_instance_server.nodes-zone-2.*.public_ip}"
  depends_on       = [scaleway_lb.loadbalancer, scaleway_instance_server.nodes-zone-2]
}


### Création de la route des frontends aux backends pour les zones 1 et 2
resource "scaleway_lb_route" "route-zone-1" {
  count       = var.instance_count_zone_1
  frontend_id = "${scaleway_lb_frontend.frontend-zone-1[count.index].id}"
  backend_id  = "${scaleway_lb_backend.backend-zone-1[count.index].id}"
  match_sni   = "scaleway.com"
}
resource "scaleway_lb_route" "route-zone-2" {
  count       = var.instance_count_zone_2
  frontend_id = "${scaleway_lb_frontend.frontend-zone-2[count.index].id}"
  backend_id  = "${scaleway_lb_backend.backend-zone-2[count.index].id}"
  match_sni   = "scaleway.com"
}


# Output des valeurs à passer au fichier output.tf (IP et Nom des instance des zones 1 et 2)
output "webserver_names_zone_1" {
  value = ["${scaleway_instance_server.nodes-zone-1.*.name}"]
}
output "webserver_ips_zone_1" {
  value = ["${scaleway_instance_server.nodes-zone-1.*.public_ip}"]
}
output "webserver_names_zone_2" {
  value = ["${scaleway_instance_server.nodes-zone-2.*.name}"]
}
output "webserver_ips_zone_2" {
  value = ["${scaleway_instance_server.nodes-zone-2.*.public_ip}"]
}



# Affichage de l'adresse IP publique du loadbalancer
output "loadbalancer_ip" {
  value = ["${scaleway_lb_ip.loadbalancer-ip.ip_address}"]
}