#!/bin/bash

set -euo pipefail

VERSION_REGEX='^v[0-9]+.[0-9]+.[0-9]+$'
OWNER=liquibase
REPO=liquibase-package-manager
TAGS_COUNT=15

VER_TEST=0
BUILD=1
UPLOAD=0

get_github_tags()
{
    git ls-remote --tags https://github.com/${OWNER}/${REPO}.git \
    | cut -d'/' -f3- \
    | cut -d'^' -f1 \
    | grep -E "$VERSION_REGEX" \
    | sort -V \
    | uniq \
    | tail -"$TAGS_COUNT"
}

make() 
{
    mapfile -t versions < <(get_github_tags)
    
    for v in "${versions[@]}"; do
	if [ "${BUILD}" -eq 1 ]; then
	    ./scripts/build_in_docker.sh "$v"
	fi
	if [ "${UPLOAD}" -eq 1 ]; then
	    ./scripts/release.sh "$v"
	fi
	rm -rf srcs
    done
}

main()
{
    get_github_tags
    [ "${VER_TEST}" -eq 0 ] && make
}

main
