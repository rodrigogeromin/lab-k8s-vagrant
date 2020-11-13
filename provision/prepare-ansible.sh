#!/bin/bash

git clone https://github.com/kubernetes-sigs/kubespray.git
sudo chown vagrant. kubespray -R
cd kubespray
cp -a inventory/sample inventory/bexs/
cp -a /home/vagrant/files/inventory.ini inventory/bexs/
sudo pip3 install -r requirements.txt

