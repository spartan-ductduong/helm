#!/bin/bash

GITHUB_TOKEN=$1

GITHUB_ORGS=(
  Agora-Livecast
  Agora-Ursa
  charge-fuze
  Liquidity-Financial
  NuKeyHQ
)

for org in "${GITHUB_ORGS[@]}"; do
  git remote add "$org" git clone https://"$GITHUB_TOKEN"@github.com/"$org"/infra-helm
  git push -u "$org" --force
  git push -u "$org" --tags --force
done
