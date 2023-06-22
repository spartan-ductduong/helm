#!/bin/sh
# Declare version of index.yaml and Chart.yaml
INDEX_VERSION=0.1.0
CHART_VERSION=0.1.0
PROJECT_NAME=chargefuze

if [ ! -f /hosting/index.yml ]; then
  helm repo index hosting
fi

# Make sure that yq is installed
if ! [ "$(command -v yq)" ]; then
  apt install yq -y
  apt install yj -y
fi

# Get the value "version" of the chargefuze entry in index.yaml
INDEX_VERSION=$(yq '.entries.chargefuze' hosting/index.yaml  | grep "version"| sort -r|head -n 1|yq '.version')
#get the "version" of chargefuze/Chart.yaml
CHART_VERSION=$( yq '.version' chargefuze/Chart.yaml ) 

if [ "$CHART_VERSION" \> "$INDEX_VERSION" ]; then
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