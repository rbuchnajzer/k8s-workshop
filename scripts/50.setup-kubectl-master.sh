#!/bin/bash

. ./env

ssh $master << EOF
sudo mkdir -p $home/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $user:$user $home/.kube/config

sudo mkdir -p /home/devops/.kube
sudo cp /etc/kubernetes/admin.conf /home/devops/.kube/config
sudo chown centos:centos /home/devops/.kube/config
EOF