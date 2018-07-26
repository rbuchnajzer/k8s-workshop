#!/bin/bash

. ./env

for index in ${!servers[@]} 
do
    server=${servers[$index]}
	doctl compute droplet create $server \
		--region   tor1 \
		--image    centos-7-x64 \
		--size     4gb \
        --enable-private-networking \
        --user-data-file ./user-data.sh \
		--ssh-keys $sshkey  
		#-v
		#--wait \
done
echo "Droplets Public IPs"
doctl compute droplet list --format "Name,PublicIPv4"
