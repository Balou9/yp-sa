#!/bin/bash

# PREREQUESITES
# git
# mythril
# slither 
timestamp=$(date +%s)

mkdir "$timestamp-ypsa"
cd "$timestamp-ypsa"

repos=(
  "https://github.com/yieldprotocol/vault-v2"
  "https://github.com/yieldprotocol/yieldspace-tv"
  "https://github.com/yieldprotocol/yield-utils-v2"
  "https://github.com/yieldprotocol/strategy-v2")

for repo in ${repos[@]}; do
  git clone "$repo"
done
