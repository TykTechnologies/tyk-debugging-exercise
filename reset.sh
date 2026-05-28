#!/usr/bin/env bash
# Re-seed the broken state between candidates.
# Restores the committed (broken) config and brings the stack back up clean.
set -euo pipefail
cd "$(dirname "$0")"

echo "Restoring broken config from git..."
git checkout -- conf/

echo "Tearing down stack and volumes..."
docker compose down -v

echo "Starting fresh (broken) stack..."
docker compose up -d

echo "Done. Stack is back to its broken starting state."
