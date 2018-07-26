#!/bin/bash

. ./env

for index in ${!servers[@]} 
do
    server=${servers[$index]}
	doctl compute droplet delete $server -f
done