#!/bin/bash
. ./env

ssh $master << EOT
kubectl label nodes $ingress_node ingress=nginx

cat << EOF | tee nginx-conf.yaml 
controller:
  image:
    pullPolicy: Always
  hostNetwork: true
  nodeSelector: {ingress: "nginx"}
  metrics:
    enabled: true
rbac:
  create: true
  serviceAccountName: sa-nginx-ingress
EOF

helm install stable/nginx-ingress --name nginx-ingress -f  nginx-conf.yaml --namespace nginx-ingress
rm nginx-conf.yaml

EOT

echo "Ingress Controller installed at http://$ingress"