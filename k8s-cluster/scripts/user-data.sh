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
 
      Kubernetes Commands
 
      1. Initializes cluster master node:
      #. List Namespaces
      kubectl get namespaces

      #. List PODs (e.g. in namespace kube-system)
      kubectl get pods -n kube-system

      #. List Endpoints (e.g. in namespace kube-system)
      kubectl get ep -n kube-system

      #. List Services (e.g. in namespace kube-system)
      kubectl get svc -n kube-system

      #. List Ingress Rules (e.g. in namespace kube-system)
      kubectl get ing -n kube-system
      
packages:
  - docker
  - kubelet
  - kubeadm 
  - kubectl
runcmd:
  - modprobe br_netfilter
  - sed -i 's/\SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
  - setenforce 0
  - touch /etc/cloud/cloud-init.disabled
  - hostnamectl set-hostname $HOSTNAME
  - hostnamectl set-icon-name $HOSTNAME
  - sysctl net.bridge.bridge-nf-call-iptables=1
  - sysctl net.bridge.bridge-nf-call-ip6tables=1
  - systemctl enable docker
  - systemctl start docker
  - systemctl enable kubelet
  - systemctl start kubelet
    