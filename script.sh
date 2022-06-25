#!/bin/sh
sudo adduser --shell /bin/bash --gecos '' ansible --disabled-password
echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
mkdir /home/ansible/.ssh/ && echo ${var.public_ssh_key} >> /home/ansible/.ssh/authorized_keys
