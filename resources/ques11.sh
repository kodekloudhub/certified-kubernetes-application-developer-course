#!/bin/bash

cd /tmp/.script/resources

# Define the commands to deploy the helm chart
helm install webpage-server-01 --namespace=default ./old-version

# Moving the new version app directory 
mv /tmp/.script/resources/new-version /root/

# Removing the script 
rm -rf /tmp/.script

