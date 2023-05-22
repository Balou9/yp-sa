#!/bin/bash
# remove all security analysis attempt
# ls | grep "sa$" | while read -r line
# do
#   printf '%s\n' "$line" && rm -rf "$line"
# done

# PREREQUESITES
# git
# slither-analyzer
# solc-select
user_name=$1
repos=(
  "vault-v2"
  "yieldspace-tv"
  "yield-utils-v2"
  "strategy-v2")

for repo in "${repos[@]}"; do
  if [ ! -d "$repo" ]; then
    git clone "https://github.com/$user_name/$repo"
  fi
done

find $PWD -print | grep '.sol$' >> solfiles.txt

while IFS= read -r sol_path;
do
  slither "$sol_path" --checklist
done < solfiles.txt > "$user_name-slither-report.md"
