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