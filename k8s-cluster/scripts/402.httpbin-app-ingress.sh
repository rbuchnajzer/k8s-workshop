#!/bin/bash
. ./env

ssh $master << EOT
cat << EOF > httpbin-app-ingress.yaml
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: httpbin-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: httpbin.$ingress.nip.io
    http:
      paths:
      - backend:
          serviceName: httpbin
          servicePort: 8000
EOF

kubectl apply -f httpbin-app-ingress.yaml
EOT
