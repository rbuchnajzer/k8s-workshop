#!/bin/bash
. ./env

ssh $master << EOT

cat << EOF | tee dashboard-conf.yaml 
service:
  type: NodePort
  nodePort: 32443
ingress:
  enabled: true
  annotations: 
    kubernetes.io/ingress.class: nginx
    kubernetes.io/ingress.allow-http: "false"
    ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.org/ssl-backends: "kubernetes-dashboard"
    nginx.ingress.kubernetes.io/secure-backends: "true"
  path: /
  hosts: 
    - dashboard.$ingress.nip.io
  tls:
    - secretName: kubernetes-dashboard-certs
      hosts:
        - dashboard.$ingress.nip.io
  rbac:
    clusterAdminRole: true
  serviceAccount:
    name: admin-user
EOF

helm install stable/kubernetes-dashboard \
--name kubernetes-dashboard -f  dashboard-conf.yaml \
--namespace kube-system


EOT
