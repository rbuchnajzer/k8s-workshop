#!/bin/bash
. ./env

ssh $master << EOT

if [ ! -d "certs" ]; then
  mkdir certs 
fi
cd certs

# Create root key
openssl genrsa -out "root-ca.key" 4096

# Generate CSR
openssl req \
-new -key "root-ca.key" \
-out "root-ca.csr" -sha256 \
-subj '/C=CA/ST=QC/L=Montreal/O=K8S/CN=localhost'

# Create root-ca config
cat << EOF | tee root-ca.cnf
[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash
EOF

# Sign root certificate
openssl x509 -req  -days 3650  -in "root-ca.csr" \
-signkey "root-ca.key" -sha256 -out "root-ca.crt" \
-extfile "root-ca.cnf" -extensions \
root_ca

#-----------------------------------------------
cat << EOF | tee dashboard.cnf
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]

[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.0 = dashboard.$ingress.nip.io
IP.0 = $ingress
EOF

# Create Dashboard Key
openssl genrsa -out "dashboard.key" 4096

# Create Dashboard CSR
openssl req -new -key "./dashboard.key" -out "dashboard.csr" -sha256 \
-subj '/C=CA/ST=QC/L=Montreal/O=K8S/CN=dashboard'

# Sign Dashboard 
openssl x509 -req -CAcreateserial -sha256 \
-CA root-ca.crt -CAkey root-ca.key -days 3650 -extensions v3_req \
-extfile dashboard.cnf \
-in dashboard.csr -out dashboard.crt

kubectl create secret tls kubernetes-dashboard-certs \
  --cert=/home/centos/certs/dashboard.crt \
  --key=/home/centos/certs/dashboard.key \
  --namespace kube-system


#kubectl create serviceaccount cluster-admin-dashboard-sa
#
#kubectl create clusterrolebinding cluster-admin-dashboard-sa \
#  --clusterrole=cluster-admin \
#  --serviceaccount=kub-system:cluster-admin-dashboard-sa

EOT