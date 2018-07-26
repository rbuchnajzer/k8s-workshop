#!/bin/bash

. ./env

for index in ${!servers[@]} 
do
server=${servers[$index]}

ssh $server << EOT
sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo sysctl net.bridge.bridge-nf-call-ip6tables=1
sudo touch /etc/cloud/cloud-init.disabled
sudo hostnamectl set-hostname $server
sudo hostnamectl set-icon-name $server
EOT

# Docker
ssh $server << EOT
sudo apt-get update
sudo apt-get install -y docker.io 
sudo systemctl enable docker
sudo systemctl start docker
EOT

# Kubernetes
ssh $server << EOT
sudo apt-get update
sudo apt-get install -y apt-transport-https curl
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo systemctl enable kubelet
sudo systemctl start kubelet
EOT

done
