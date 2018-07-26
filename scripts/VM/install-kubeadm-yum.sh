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
sudo yum update -y
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
EOT

# Kubernetes
ssh $server bash -c "\
cat << EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
"
ssh $server << EOT
sudo setenforce 0
sudo yum install -y kubelet kubeadm kubectl
sudo systemctl enable kubelet
sudo systemctl start kubelet
EOT

# Install ceph 
ssh $server << EOT
sudo yum install -y ceph-common curl socat
sudo sed -i 's/\SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sudo modprobe rbd
sudo hostnamectl status
EOT


done
