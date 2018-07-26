#!/bin/bash
. ./env

ssh $master << EOT

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

kubectl apply -f busybox.yaml
rm busybox.yaml
EOT
