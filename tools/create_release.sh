#!/bin/bash

SEMTAG='./tools/semtag'
ACTION=${1:-patch}

git fetch origin --tags

RELEASE_VERSION="$($SEMTAG final -s $ACTION -o)"

echo "Next release version: $RELEASE_VERSION"

sed -i "/^version:/c version: $RELEASE_VERSION" chargefuze/Chart.yaml

mkdir -p ./hosting
helm package chargefuze -d ./hosting
helm repo index hosting --merge ./hosting/index.yaml

npm version "$RELEASE_VERSION" -no-git-tag-version
git commit -m "chore: bump version to $RELEASE_VERSION" -a
git push origin master

$SEMTAG final -s $ACTION -v "$RELEASE_VERSION"
