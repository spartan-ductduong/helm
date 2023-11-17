#!/bin/bash

GITHUB_ORGS=(
  Agora-Livecast
  Agora-Ursa
  charge-fuze
  Liquidity-Financial
  NuKeyHQ
)

for org in "${GITHUB_ORGS[@]}"; do
  git remote add "$org" git@github.com:"$org"/infra-helm.git
  git push -u "$org" --force
  git push -u "$org" --tags --force
done

