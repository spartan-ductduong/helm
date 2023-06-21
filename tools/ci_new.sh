#!/bin/sh
# Declare version of index.yaml and Chart.yaml
INDEX_VERSION="0.1.0"
CHART_VERSION="0.1.1"

if [ ! -f /hosting/index.yml ]; then
  helm repo index hosting
fi

# Make sure that yq is installed
if ! [ -x "$(command -v yq)" ]; then
  sudo apt install yq -y
  sudo apt install yj -y
fi

# Get the value "version" of the chargefuze entry in index.yaml
yq '.entries.chargefuze[0].version' hosting/index.yaml > INDEX_VERSION

#get the "version" of chargefuze/Chart.yaml
yq '.version' chargefuze/Chart.yaml > CHART_VERSION

if [ "$CHART_VERSION" > "$INDEX_VERSION" ]; then
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
