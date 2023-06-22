#!/bin/bash

SEMTAG='./tools/semtag'
ACTION=${1:-patch}

git fetch origin --tags

RELEASE_VERSION="$($SEMTAG final -s $ACTION -o)"

echo "Next release version: $RELEASE_VERSION"

sed -i "/^version:/c version: $RELEASE_VERSION" charts/chargefuze/Chart.yaml
sed -i "/^appVersion:/c appVersion: $RELEASE_VERSION" charts/chargefuze/Chart.yaml

mkdir -p ./hosting

helm package charts/chargefuze -d ./hosting
helm repo index hosting --merge ./hosting/index.yaml

git add ./hosting
git add chargefuze/Chart.yaml

git commit -m "chore: bump version to $RELEASE_VERSION" -a
git push origin master

$SEMTAG final -s $ACTION -v "$RELEASE_VERSION"
