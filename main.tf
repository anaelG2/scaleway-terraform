terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

resource "scaleway_account_ssh_key" "main" {
    name       = "main"
    public_key = var.public_ssh_key
    project_id = var.scaleway_project_id
}

resource "scaleway_lb_ip" "loadbalancer-ip" {
  zone = "fr-par-1"
  project_id = var.scaleway_project_id
}

resource "scaleway_lb" "loadbalancer" {
  ip_id      = scaleway_lb_ip.loadbalancer-ip.id
  zone       = scaleway_lb_ip.loadbalancer-ip.zone
  project_id = var.scaleway_project_id
  name       = "loadbalancer"
  type       = "LB-S"
  depends_on = [
    scaleway_lb_ip.loadbalancer-ip
  ]
}

resource "scaleway_instance_security_group" "scaleway_security_group" {
  project_id              = var.scaleway_project_id
  name                    = "security-group"
  inbound_default_policy  = "accept"
  outbound_default_policy = "accept"
}