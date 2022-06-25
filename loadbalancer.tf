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