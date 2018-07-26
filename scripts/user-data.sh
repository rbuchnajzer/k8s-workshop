#cloud-config
write_files:
  - path: /etc/yum.repos.d/kubernetes.repo
    owner: root:root
    permissions: '0444'
    content: |
      # installed by cloud-init
      [kubernetes]
      name=Kubernetes
      baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
      enabled=1
      gpgcheck=1
      repo_gpgcheck=1
      gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
             https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
  - path: /etc/motd
    owner: root:root
    permissions: '0644'
    content: |
 
      Bootstrap Kubernetes Cluster
 
      1. Initializes cluster master node:
      kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr=192.168.0.0/16
 
 
      2. Initialize calico networking:
      kubectl apply -f https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml
 
packages:
  - docker
  - kubelet
  - kubeadm 
  - kubectl
  - git
runcmd:
  - setenforce 0
  - systemctl enable docker
  - systemctl start docker
  - systemctl enable kubelet
  - systemctl start kubelet
  - touch /etc/cloud/cloud-init.disabled
  - hostnamectl set-hostname $HOSTNAME
  - hostnamectl set-icon-name $HOSTNAME
  - sysctl net.bridge.bridge-nf-call-iptables=1
  - sysctl net.bridge.bridge-nf-call-ip6tables=1  # set port and disable authentication with passwords
