# Kubernetes

This repo contains bash scripts to install and explore kubernetes on the public cloud provider Digital Ocean. The defult configuration creates 4 VM's (Droplets)
with 4 GB Memory (hourly rate $0.03 each).

The intention of the provided bashscripts is to quickly spin up/tear down Droplets, and install the following components
   
- A 4 Nodes Kubernetes Cluster
- Helm Package Master
- Nginx Ingress Controller
- Kubernetes Dashboard
- Prometheus Operator (Prometheus, Grafana)

The DNS service from nip.io is used to generate url's for the Dashboard, Prometheus and Grafana.


## Prerequsits

- Register on account on [Digitalocean](https://www.digitalocean.com).
- Upload your a SSH public key (~/.ssh/id_rsa.pub).
- Generate an API Key (for doctl) on the  Digital Ocean Webportal.
- Install the doctl Comand Line Intrface (cli) [download doctl](https://github.com/digitalocean/doctl)


## Cloning the installation scripts.
This repo should be cluned under ~/.ssh/repos to include the ssh-config in the ssh config file ~/.ssh/config. 

```
mkdir -p ~/.ssh/repos
cd ~/.ssh/repos
git clone https://github.com/pellepedro/k8s-workshop

```

Create/Edit the file ~/.ssh/config and add Include of the ssh-config generated in the scripts directory. This will setup ssh credentials to access the do Droplets as "ssh master", "ssh node1", "ssh node2", "ssh node3" etc.


```
Include ./repos/k8s-workshop/scripts/ssh-config

```

### Configure 
Review the file scripts/env that contains configuration, e.g the number of droplets and the droplet that are assigned for the ingress controller. 


### Installation

```
cd ~/.ssh/repos/k8s-workshop/scripts
```

#### Create Droplets

```
./10.digital-ocean-create-droplets.sh
```

#### Create SSH Config
```
./20.digital-ocean-create-ssh-config.sh
```

#### Init the Master Node
```
./30.kubeadm-init-master.sh
```

#### Join Compute Nodes
```
./40.kubeadm-join-nodes.sh
``` 

#### Setup kubectl command on Master
```
./50.setup-kubectl-master.sh
```

#### Install calico cluster Network
```
./60.deploy-calico-network.sh
```

### Generate TLS Certificates
```
./70.generate-certificates.sh
```

#### Install Helm
```
./100.k8s-install-helm.sh
```

#### Install Nginx Ingress Controller
```
./200.k8s-install-nginx.sh
```

### Install Kubernetes Dashboard
```
./210.deploy-dashboard.sh
```

### Install Kubernetes Dashboard
```
./210.deploy-dashboard.sh
```

### Generate a Service Account with cluster-admin role.
```
./220.create-cluster-admin-token.sh
```

### Install Prometheus/Grafana 
```
./300.k8s-install-prometheus.sh
```

### Install Sample Metrics App
```
./300.k8s-install-prometheus.sh
```



# Docker Image
The installation sripts are available as a docker image.

```
docker run -it pellepedro/k8s-install:0.1.0
```

## Copy and paste your public and private ssh key to the container
```
vim /root/.ssh/id_rsa.pub
vim /root/.ssh/id_rsa
```

## Installation scripts are available at.
```
cd ~/scripts/digitalocean/
```