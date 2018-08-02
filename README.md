# Kubernetes Cluster

This repo contains bash scripts to install and explore kubernetes on the public cloud provider Digital Ocean.

The intention of the provided bashscripts is to quickly spin up/tear down Droplets, and install the following components
   
- A 4 Nodes Kubernetes Cluster
- Helm Package Master
- Nginx Ingress Controller
- Kubernetes Dashboard
- Prometheus Operator (Prometheus, Grafana)

The DNS service from nip.io is used to generate url's for the Dashboard, Prometheus and Grafana.

# Installation

## Admin Droplet (VM)

Log in to your account on Digital Ocean, and create an Admin Droplet that will act as an installation VM for the kubernetes cluster.

### Admin Droplet Specification

- OS : Ubuntu 18.04
- Memory : 1GB, 1vCPU
- Region : Toronto
- Enable Private Networking
- User data : Copy contents of file [admin-host/user-data.txt](admin-host/user-data.txt)
- Select you private key for the droplet.
- Name the droplet admin   
   
The web UI will display the progress of the Droplet  creation. Once comlpeted, it's IP will be displayed. 

## Installation of a Kubernetes cluster.

- Log in to the admin droplet   
```
ssh root@<admin ip>
```   
   
Issue the command "docker --version" to ensure that the cloud init script has completed. If the docker command is not available, wait a minute and retry the command, until the command to print the docker version is successfully executed.   
   
During the creation of the admin droplet, a unique set of public/private keys are created and stored under ~/.ssh .   
   
- Print the public ssh key on the admin node, and copy/paste it's contens as a new ssh key on the WEB UI of your Digital Ocean account, with the name admin.

```
cat ~/.ssh/id_rsa.pub
# e.g.
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC....Pqeu8picDkT1ap+aYPWwRnOucFEoFnXEv root@admin
```   
   
- Select the tab "API" on the Digital Ocean Web UI and generate a new Access Token, with name k8s-admin and read/write access.


#### Starting the installer container on the admin node.  
```
docker run -it -v /root/.ssh:/root/.ssh -e DIGITALOCEAN_ACCESS_TOKEN=<access_token> pellepedro/k8s-install:0.1.0
```

#### Installation Scripts

```
./10.digital-ocean-create-droplets.sh
./20.digital-ocean-create-ssh-config.sh

# The creation of droplets with loud-init script might take
# a couple of minutes. Therefore wait and repeate script
# 30.kubeadm-init-master.sh untill sucess

./30.kubeadm-init-master.sh
./40.kubeadm-join-nodes.sh
./50.setup-kubectl-master.sh
./60.deploy-calico-network.sh

# Generate Certificates for the Dashboard
./70.generate-certificates.sh
./100.k8s-install-helm.sh 
./200.k8s-install-ingress.sh
./210.deploy-dashboard.sh 
./220.create-cluster-admin-token.sh
./310.prometheus-metrics-app.sh 

```

# Kubernetes Commands

```
# List Namespaces
kubectl get ns

# List Deployments (in namespace kube-system)
kubectl get deployments -n kube-system

# List PODs (in namespae kube-system)
kubectl get pods -n kube-sustem

# List Services (in namespace kube-system)
kubectl get svc -n kube-sustem

# List Endpoints (in namespace kube-system)
kubectl get ep -n kube-sustem

```

