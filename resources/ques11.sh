#!/bin/bash

cd /tmp/.script

# Define the commands to deploy the helm chart

helm install webpage-server-01 --namespace=default ./old-version

mv /tmp/.script/new-version /root/

# Removing the script 

rm -rf /tmp/.script

