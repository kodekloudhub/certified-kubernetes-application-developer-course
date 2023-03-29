#!/bin/bash

cd /tmp/.ques10

# Define the commands to be executed
command1="helm install security-alpha-apd --namespace=security-alpha-01 ./security-alpha-apd"
command2="helm install digi-locker-apd --namespace=digi-locker-02 ./digi-locker-apd"
command3="helm install web-dashboard-apd --namespace=web-dashboard-03 ./web-dashboard-apd"
command4="helm install atlanta-page-apd --namespace=atlanta-page-04 ./atlanta-page-apd"

sleep 2

# Loop until all commands have executed successfully
while true; do
  # Execute the commands
   $command1 && $command2 && $command3 && $command4
  
  # Check if any command failed
  if [ $? -ne 0 ]; then
    # If a command failed, print an error message and try once again and then exit the loop
    echo "One or more commands failed. Retrying..."
    $command1 && $command2 && $command3 && $command4
    break
  
  else
    # If all commands succeeded, exit the loop
    break
  fi
done

echo "All commands executed successfully."
