#!/bin/bash
  
# Define the name of the deployment we want to check
DEPLOYMENT_NAME="test-v2-apd"

# Using kubectl command to list the deployment in the default namespace
kubectl get deployment $DEPLOYMENT_NAME -n default > /dev/null 2>&1

# Check the exit status of the previous command to see if the deployment exists
if [ $? -eq 0 ]; then
  total_ep=$(kubectl get  ep test-apd-svc -n default -o json | jq -r .subsets[].addresses | jq length)
  canary_ep=$(kubectl get deployments.apps test-v2-apd -n default -o json |  jq -r .status.availableReplicas)
  traffic_pct=$(echo "scale=3; $canary_ep / $total_ep * 100" | bc -l)
  if (( $(echo "$traffic_pct > 50" |bc -l) )); then
           exit 255
  fi
else

# If it does not exist, then it will exit it. 
     exit 255
fi
