# Kubernetes

This repo contains bash scripts to install and explore kubernetes on the public cloud provider Digital Ocean. 

The intention of the provided bashscripts is to quickly spin up/tear down Droplets, and install the following components
   
- A 4 Nodes Kubernetes Cluster
- Helm Package Master
- Nginx Ingress Controller
- Kubernetes Dashboard
- Prometheus Operator (Prometheus, Grafana)

The DNS service from nip.io is used to generate url's for the Dashboard, Prometheus and Grafana.

## Install admin droplet

Create a droplet on digital ocean using the user data file under admin-host

##