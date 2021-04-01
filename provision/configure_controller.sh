#!/bin/bash

cd configure-controller

sudo curl -L https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sed 's/\/usr\/local\/bin/\/usr\/local\/sbin/g' | bash

sudo pip3 install -r requirements.txt

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo -u vagrant /usr/local/bin/ansible-galaxy collection install -r requirements.yml
/usr/local/bin/ansible-galaxy collection install -r requirements.yml

/usr/local/bin/ansible-playbook -i inventory.ini configure.yml
