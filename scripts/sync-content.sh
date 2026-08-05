#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

echo "==> Init submodule if needed"
git submodule update --init --recursive

echo "==> Fetching latest content from submodule remote"
git submodule update --remote content

if git diff --quiet HEAD -- content; then
  echo "==> Submodule already up to date, triggering an empty commit instead"
  git commit --allow-empty -m "Trigger rebuild"
else
  echo "==> Submodule pointer changed, committing the update"
  git add content
  git commit -m "Update content submodule"
fi

echo "==> Pushing to origin"
git push

echo "==> Done"
