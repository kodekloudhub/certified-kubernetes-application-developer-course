#!/bin/bash
until [[ `kubectl get pods -n alpha-ns-apd| grep cube-alpha-apd | grep Running` ]]; do sleep 1s; done
total_ep=$(kubectl get  ep alpha-apd-service -n alpha-ns-apd -o json | jq -r .subsets[].addresses | jq length)
canary_ep=$(kubectl get deployments.apps cube-alpha-apd -n alpha-ns-apd -o json |  jq -r .status.availableReplicas)
traffic_pct=$(echo "scale=5; $canary_ep / $total_ep * 100" | bc -l)
if (( $(echo "$traffic_pct > 40" |bc -l) )); then
        exit 255
fi
