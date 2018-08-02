#!/bin/bash
. ./env

ssh $master << EOT
cat << EOF > httpbin-app-service.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: httpbin
  labels:
    app: httpbin
spec:
  ports:
  - name: http
    port: 8000
  selector:
    app: httpbin
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

kubectl apply -f httpbin-app-service.yaml
EOT
