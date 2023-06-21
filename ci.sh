#!/bin/bash

index_version=S1
chart_version=S2

if [ ! -f /hosting/index.yml ]; then
  helm repo index hosting
fi

# Get the value "version" of the chargefuze entry in index.yaml

yq '.entries.chargefuze[0].version' hosting/index.yaml > index_version

#get the "version" of chargefuze/Chart.yaml
yq '.version' chargefuze/Chart.yaml > chart_version

if [ "$chart_version" > "$index_version" ]; then
  echo "New version found"
  # Create new version packaged chart in hosting
  helm package chargefuze -d ./hosting
  # Update the index.yaml
  helm repo index hosting --merge ./hosting/index.yaml
  # Commit and push the changes
  git add .
  git commit -m "New version update"
  git push
fi