#!/bin/bash
. ./env

ssh $master << EOT

cat << EOF | tee cluster.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: rook-ceph
---
apiVersion: ceph.rook.io/v1beta1
kind: Cluster
metadata:
  name: rook-ceph
  namespace: rook-ceph
spec:
  dataDirHostPath: /var/lib/rook
  dashboard:
    enabled: true
  storage:
    useAllNodes: true
    useAllDevices: false
    config:
      databaseSizeMB: "1024"
      journalSizeMB: "1024"
EOF

kubectl apply -f cluster.yaml

EOT
