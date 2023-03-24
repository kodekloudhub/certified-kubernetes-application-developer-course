#!/bin/bash

if grep -q -w "garuda-secret-apd" /root/apps-release-names.txt && grep -q -w "garuda-web-apd" /root/apps-release-names.txt; then
    echo "TRUE"
else
    echo "FALSE"
fi

