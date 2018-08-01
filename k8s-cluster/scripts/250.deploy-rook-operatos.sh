#!/bin/bash
. ./env

ssh $master << EOT
helm repo add rook-beta https://charts.rook.io/beta
helm install --namespace rook-ceph-system rook-beta/rook-ceph
EOT
