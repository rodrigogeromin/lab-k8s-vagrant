#!/bin/bash

cd configure-controller

sudo curl -L https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sed 's/\/usr\/local\/bin/\/usr\/local\/sbin/g' | bash

sudo pip3 install -r requirements.txt

sudo -u vagrant /usr/local/bin/ansible-galaxy collection install -r requirements.yml
/usr/local/bin/ansible-galaxy collection install -r requirements.yml

/usr/local/bin/ansible-playbook -i inventory.ini configure.yml
