#!/bin/bash
. ./env

ssh $master << EOT
helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
helm install coreos/prometheus-operator --name prometheus-operator --namespace monitoring

cat << EOF | tee kube-prom-conf.yaml
global:
  rbacEnable: true 
grafana:
  ingress:
    enabled: true
    annotations: {kubernetes.io/ingress.class: "nginx"}
    hosts:
      - grafana.${ingress}.nip.io
prometheus:
  deployExporterNode: false
  deployKubelets: false
  deployKubeScheduler: false
  deployKubeControllerManager: false
  deployKubeState: false
  ingress:
    enabled: true
    annotations: {kubernetes.io/ingress.class: "nginx"}
    hosts:
      - prometheus.$ingress.nip.io
EOF

helm install coreos/kube-prometheus --name kube-prometheus --namespace monitoring -f kube-prom-conf.yaml

echo "Grafana url http://grafana.${ingress}.nip.io"
echo "Prometheus url http://prometheus.${ingress}.nip.io"