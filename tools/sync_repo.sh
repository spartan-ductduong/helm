#!/bin/bash

GITHUB_TOKEN=$1

GITHUB_ORGS=()

for org in "${GITHUB_ORGS[@]}"; do
  git remote add "$org" https://"$GITHUB_TOKEN"@github.com/"$org"/infra-helm
  git push -u "$org" --force
  git push -u "$org" --tags --force
done
