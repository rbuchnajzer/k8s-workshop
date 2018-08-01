#!/bin/bash

. ./env

ssh $master "sudo kubeadm init --token-ttl=0 --pod-network-cidr=192.168.0.0/16 | grep -- --token |  sed 's/^[ \t]*//' | sudo tee /etc/kubernetes/token"