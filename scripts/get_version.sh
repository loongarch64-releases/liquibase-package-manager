#!/bin/bash
set -euo pipefail

UPSTREAM_OWNER=liquibase
UPSTREAM_REPO=liquibase-package-manager

curl -s https://api.github.com/repos/"$UPSTREAM_OWNER"/"$UPSTREAM_REPO"/releases/latest \
     | jq -r ".tag_name"
