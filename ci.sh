#!/bin/bash
# Declare version of index.yaml and Chart.yaml
index_version=0.1.0
chart_version=0.1.0

if [ ! -f /hosting/index.yml ]; then
  helm repo index hosting
fi

# Make sure that yq is installed
if ! [ -x "$(command -v yq)" ]; then
  apt install yq -y
  apt install yj -y
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