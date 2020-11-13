#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False

sudo chmod 700 files/id_rsa

cd kubespray
/usr/local/bin/ansible-playbook --private-key /home/vagrant/files/id_rsa -i inventory/bexs/inventory.ini cluster.yml
