#!/bin/bash
. ./env

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
        image: fabxc/instrumented_app
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
EOF

kubectl create namespace metrics-app
kubectl apply -f app.yaml -n metrics-app
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
       - metrics-app
  endpoints:
  - port: web
    interval: 10s
    honorLabels: true
EOF

kubectl apply -f service-monitor.yaml
rm service-monitor.yaml
EOT
