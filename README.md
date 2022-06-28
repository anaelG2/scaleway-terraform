Terraform Scaleway - Serveurs Webs HA 
=========

Script Terraform permettant de provisionner un cluster de serveurs scaleway en haute-disponibilité sur une zone unique. La quantité de serveurs peut être définie, les serveurs sont exposés via un loadbalancer provisionné chez Scaleway également. Pour cela, le script Terraform utilise le module "Provider" de Scaleway. Le script génère également un inventaire dynamique prêt à être utilisé avec un playbook ansible.

Les ressources provisionnées par le script sont les suivantes : 
- scaleway_loadbalancer (ip, backend, frontend, route)
- scaleway_security_group 
- scaleway_instance_server 
- scaleway_bucket


Prérequis
------------

Les variables d'environnement suivantes doivent être définies : 
- `export SCW_ACCESS_KEY=XXXXXXXXXXXXXXXXXXX` 
- `export SCW_SECRET_KEY=XXX-XXX-XXX-XXX-XXX` 


Utilisation
------------

1. Personnaliser le playbook en modifiant les valeurs des variables dans le fichier "vars.tf"

2. Appliquez les commandes suivantes : 
    - `terraform plan` pour obtenir un aperçu du plan d'exécution
    - `terraform apply` pour créer les ressources
    - `terraform destroy` pour détruire les ressources


Variables du script
--------------

Voici les différentes variables qui sont utilisées dans ce rôle : 

| Variable  | Description |
| --- | --- |
| projet_name  | Nom du projet |
| scaleway_project_id  | ID Scaleway du projet |
| public_ssh_key  | Clé SSH à ajouter au compte Scaleways |
| scaleway_region  | Région Scaleway sur laquelle créer la ressource. [voir plus](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/guides/regions_and_zones) |
| scaleway_zone  | Zone Scaleway sur laquelle créer la ressource. [voir plus](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/guides/regions_and_zones) |
| instance_count  | Quantité d'instances à créer |
| webserver_node_name  | Modèle de nom des instances (sera indexé selon le modèle d'exemple suivant "modele-1") |
| instance_type  | Type d'instances à créer. [voir plus](https://developers.scaleway.com/en/products/instance/api/#servers-8bf7d7) |
| scaleway_loadbalancer_name  | Nom assigné au loadbalancer |
| scaleway_bucket_name  | Nom assigné au bucket |
