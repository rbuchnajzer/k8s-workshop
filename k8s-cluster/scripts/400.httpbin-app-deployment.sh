#!/bin/bash
. ./env

ssh $master << EOT
cat << EOF > httpbin-app-deployment.yaml
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: httpbin
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: httpbin
    spec:
      containers:
      - image: docker.io/citizenstig/httpbin
        imagePullPolicy: IfNotPresent
        name: httpbin
        ports:
        - containerPort: 8000
EOF

kubectl apply -f httpbin-app-deployment.yaml
EOT
