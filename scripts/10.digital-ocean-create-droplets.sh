#!/bin/bash

. ./env

for index in ${!servers[@]} 
do
    server=${servers[$index]}
	droplet_size=${server_size[$index]}
	doctl compute droplet create $server \
		--region   tor1 \
		--image    $k8s_image \
		--size     $droplet_size \
        --enable-private-networking \
        --user-data-file ./user-data.sh \
		--ssh-keys $sshkey  
done
echo "Droplets Public IPs"
doctl compute droplet list --format "Name,PublicIPv4"
