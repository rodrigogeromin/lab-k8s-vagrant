#!/bin/bash

if [ $(hostname) != "controller" ]; then
  sudo mkdir -p /root/.ssh
  sudo cp /home/vagrant/files/id_rsa /root/.ssh/id_rsa
  sudo cp /home/vagrant/files/id_rsa.pub /root/.ssh/id_rsa.pub
  sudo chmod 400 /root/.ssh/id_rsa*
  sudo cp /home/vagrant/files/id_rsa.pub /root/.ssh/authorized_keys
  sudo modprobe dm_snapshot
  sudo modprobe dm_thin_pool
  sudo modprobe dm_mirror
fi
