resource "scaleway_instance_security_group" "www" {
  project_id              = var.scaleway_project_id
  name                    = "security-group"
  inbound_default_policy  = "accept"
  outbound_default_policy = "accept"
#   inbound_rule {
#     action = "accept"
#     port   = "22"
#     ip     = "*"
#   }
#   inbound_rule {
#     action = "accept"
#     port   = "80"
#   }
#   inbound_rule {
#     action = "accept"
#     port   = "443"
#   }
}