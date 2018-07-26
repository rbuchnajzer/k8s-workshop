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

### 
```

```



**Manual Installation**
- Ensure to add your public ssh key to the digital-ocean dashboard
- Name the Droplets **master**, **node1**, **node2**, **node3**
- Create the VMs/Droplets with 4GB memory, and ad the contents of the file cloud-init.md to the user_data fild

**Post Installation**

1. Log in to the master and inititialize the master node. 
```
$ ssh centos@<master>
$ kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr=192.168.0.0/16
```
**Result**
The *kubeadm* command to join the master node from worker nodes will be printed. Copy and paste this command to a text file to keep the command at hand when joining from other nodes.

2. Create cubectl configuration
When the master is initialized, the configuration file /etc/kubernetes/admin.conf. This file contains certificates the certificate to communicate with the API server.  
Kubernetes command line tool (kubectl) looks for the file  ~/.kube/config containing certificates.


```
On the master VM, issue the following commands:

$ mkdir $HOME/.kube 
$ sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $USER:$USER $HOME/.kube/config
```   
   
Verify that *kubectl* can communicate with the API server
```
$ kubectl get nodes 
```

3. Log in to all worker noces and issue the join command.
```
ssh centos@node<1.2.3>

Issue the join command with token as previously obtained from the master.
kubeadm join ...
```

4. Log in to the master to deploy a network
```
$ ssh centos@<master>
$ kubectl apply -f https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml

It will take about 60 sec before all nodes are up in ready state.

Use the command *kubectl get nodes* to list the state of the nodes. 
$ kubectl get nodes

```


## Tutorial

Work through the following tutorials


[Run a Stateless Application](https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/)

[Use a Service to Access an Application](https://kubernetes.io/docs/tasks/access-application-cluster/service-access-application-cluster/)

[GuestBook application with Redis](https://kubernetes.io/docs/tutorials/stateless-application/guestbook/)

## Busybox
```
cat << EOF > busybox.yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  namespace: default
spec:
  containers:
  - image: busybox
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
    name: busybox
  restartPolicy: Always
EOF
```
