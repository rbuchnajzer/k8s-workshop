#!/bin/bash
. ./env

namespace=services
ssh $master << EOT
cat << EOF > app.yaml
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: metrics-app
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: metrics-app
    spec:
      containers:
      - name: metrics-app
        image: pellepedro/metrics:0.1.0
        ports:
        - name: web
          containerPort: 8080
---
kind: Service
apiVersion: v1
metadata:
  name: metrics-app
  labels:
    prometheus: kube-prometheus
    app: metrics-app
spec:
  selector:
    app: metrics-app
  ports:
  - name: web
    port: 8080
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: metrics-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: metrics.$ingress.nip.io
    http:
      paths:
      - backend:
          serviceName: metrics-app
          servicePort: 8080
EOF

kubectl create namespace $namespace
kubectl apply -f app.yaml -n $namespace
rm app.yaml

cat << EOF > service-monitor.yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: metrics-app
  namespace: monitoring
  labels:
    prometheus: kube-prometheus
spec:
  selector:
    matchLabels:
      app: metrics-app
  namespaceSelector:
    matchNames:
       - $namespace
  endpoints:
  - port: web
    interval: 10s
    honorLabels: true
EOF

kubectl apply -f service-monitor.yaml
rm service-monitor.yaml
EOT
