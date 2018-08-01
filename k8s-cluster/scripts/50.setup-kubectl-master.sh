#!/bin/bash

. ./env

ssh $master << EOF
sudo mkdir -p $home/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $user:$user $home/.kube/config

EOF