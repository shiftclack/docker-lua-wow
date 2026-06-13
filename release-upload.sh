#!/bin/bash
#
# Syntax: release-upload.sh <repo> <tag> <asset-name> <filename>
# Example: release-upload.sh ${{ github.repository }} ${{ github.event.release.tag_name }} "file-v123.zip" dist/file.zip
#
set -e

REPOSITORY="$1"
TAG="$2"
NAME="$3"
ASSET="$4"

if [[ -z $GITHUB_TOKEN ]]; then
    echo "Please set the GITHUB_TOKEN environment variable."
    exit 1
fi

release_json="$(
curl -fsSL \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/${REPOSITORY}/releases/tags/${TAG}"
)"

upload_url="$(
    printf '%s' "$release_json" \
    | sed -n 's/.*"upload_url": *"\([^"]*\){?name,label}".*/\1/p'
)"

curl -fsSL \
    -X POST \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    -H "Content-Type: application/zip" \
    --data-binary @"${ASSET}" \
    "${upload_url}?name=${NAME}"
