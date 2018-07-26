#!/bin/bash

. ./env

scp $master:/etc/kubernetes/token token
token=$(<token)
echo "$token"

function joinNode {
echo "Node $1 is joining the cluster"
node=$1
ssh $node << EOT
sudo $token
echo "sudo $token"
EOT
}


for index in ${!servers[@]} 
do
    server=${servers[$index]}
    if [ $index == 0 ]; then 
        echo "Skipping master"
    else
        joinNode $server
    fi
done

rm ./token