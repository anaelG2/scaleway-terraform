### Déclaration du provider Scaleway
terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

### Ajout clé ssh au compte Scaleway
resource "scaleway_account_ssh_key" "main" {
  name       = "main"
  public_key = var.public_ssh_key
  project_id = var.scaleway_project_id
}


### Création de l'adresse ip du loadbalancer et du loadbalancer
resource "scaleway_lb_ip" "loadbalancer-ip" {
  zone       = var.scaleway_zone
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
resource "scaleway_instance_security_group" "scaleway_security_group_zone" {
  project_id              = var.scaleway_project_id
  zone                    = var.scaleway_zone
  name                    = "security-group-${var.scaleway_region}"
  inbound_default_policy  = "accept"
  outbound_default_policy = "accept"
}


### Création des IP et instances
resource "scaleway_instance_ip" "public_ip_zone" {
  count      = var.instance_count
  project_id = var.scaleway_project_id
  zone       = var.scaleway_zone
}
resource "scaleway_instance_server" "nodes" {
  count             = var.instance_count
  project_id        = var.scaleway_project_id
  zone              = var.scaleway_zone
  name              = "${var.projet_name}-${var.webserver_node_name}-${var.scaleway_region}-${count.index + 1}"
  type              = var.instance_type
  image             = "debian_bullseye"
  tags              = ["node", "webserver", "projet-annuel"]
  ip_id             = "${scaleway_instance_ip.public_ip_zone[count.index].id}"
  security_group_id = scaleway_instance_security_group.scaleway_security_group_zone.id
  depends_on = [
    scaleway_lb.loadbalancer,
    scaleway_instance_security_group.scaleway_security_group_zone,
    scaleway_instance_ip.public_ip_zone
  ]
}

resource "scaleway_lb_backend" "backend" {
  lb_id            = scaleway_lb.loadbalancer.id
  name             = "${var.projet_name}-backend"
  forward_protocol = "tcp"
  forward_port     = 80
  proxy_protocol   = "none"
  server_ips       = "${scaleway_instance_server.nodes.*.public_ip}"
  depends_on       = [scaleway_lb.loadbalancer, scaleway_instance_server.nodes]
}
resource "scaleway_lb_frontend" "frontend" {
  # count        = var.instance_count
  lb_id        = scaleway_lb.loadbalancer.id
  backend_id   = "${scaleway_lb_backend.backend.id}"
  name         = "${var.projet_name}-frontend}"
  inbound_port = 80
  depends_on   = [scaleway_lb_backend.backend]
}


### Création de la route des frontends aux backends pour les zones 1 et 2
resource "scaleway_lb_route" "route" {
  frontend_id = "${scaleway_lb_frontend.frontend.id}"
  backend_id  = "${scaleway_lb_backend.backend.id}"
  match_sni   = "scaleway.com"
  depends_on = [scaleway_lb_frontend.frontend]
}

# Output des valeurs à passer au fichier output.tf (IP et Nom des instance des zones 1 et 2)
output "webserver_names_zone" {
  value = ["${scaleway_instance_server.nodes.*.name}"]
}
output "webserver_ips_zone" {
  value = ["${scaleway_instance_server.nodes.*.public_ip}"]
}


# Affichage de l'adresse IP publique du loadbalancer
output "loadbalancer_ip" {
  value = ["${scaleway_lb_ip.loadbalancer-ip.ip_address}"]
}