#!/bin/bash
. ./env

# This script retreive the 
ssh $master << EOT

#
# Create a ServiceAccount tied to the RBAC role
# cluster-admin
#
cat << EOF | tee admin-sa.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
EOF

kubectl apply -f admin-sa.yaml
rm admin-sa.yaml

cat << EOF | tee admin-crb.yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
EOF

kubectl apply -f admin-crb.yaml
rm admin-crb.yaml

# Retreive the token for the service account
kubectl -n kube-system get secret \
  | grep admin-user | awk '{print \$1}' | tee admin-user-token
EOT

scp $master:$home/admin-user-token admin-user-token
token=$(<admin-user-token)
echo "$token"

ssh $master << EOT
echo "--------- ADMIN TOKEN -------------"
kubectl -n kube-system describe secret/$token | grep ^token | awk '{print \$2}'
echo "----------------------------------"
EOT

