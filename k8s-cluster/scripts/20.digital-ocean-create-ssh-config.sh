#!/bin/bash

. ./env
#servers=("master")
echo "" > ssh-config
echo "creating ssh-config file"

# Add K8S Cluster
for index in ${!servers[@]} 
do
server=${servers[$index]}
ip=$(doctl compute droplet list $server --format "PublicIPv4" --no-header)
cat << EOF >> ssh-config
host $server
     user centos
     hostname $ip
     port 22
     identityfile ~/.ssh/id_rsa

EOF
done


