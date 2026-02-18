#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
PATTERN='git::https://github.com/temitayocharles/terraform-module.git//module/'

# Ensure every terraform-module source is pinned with ?ref=vX.Y.Z and never tracks main/master/HEAD.
violations=$(rg -n "$PATTERN" "$ROOT" -g '*.tf' | while IFS=: read -r file line text; do
  src="$text"
  if [[ "$src" != *"?ref="* ]]; then
    echo "$file:$line missing ?ref= pin"
    continue
  fi
  ref="${src##*?ref=}"
  ref="${ref%%\"*}"
  if [[ "$ref" =~ ^(main|master|HEAD)$ ]]; then
    echo "$file:$line forbidden floating ref '$ref'"
    continue
  fi
  if [[ ! "$ref" =~ ^v[0-9]+\.[0-9]+\.[0-9]+([.-][A-Za-z0-9.-]+)?$ ]]; then
    echo "$file:$line non-semver ref '$ref'"
    continue
  fi
done)

if [[ -n "$violations" ]]; then
  echo "Module source pin check failed:"
  echo "$violations"
  exit 1
fi

echo "Module source pin check passed"
