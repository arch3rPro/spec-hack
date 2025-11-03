#!/bin/bash
# Check if a release with the specified version already exists

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Version to check
VERSION="${1:-}"

if [ -z "$VERSION" ]; then
    echo "Error: Version must be specified"
    exit 1
fi

# Get repository information
REPO_OWNER="${GITHUB_REPOSITORY_OWNER:-arch3rPro}"
REPO_NAME="${GITHUB_REPOSITORY#*/}"

# Check if release exists using GitHub API
if command -v curl >/dev/null 2>&1; then
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/tags/v${VERSION}")
    
    if [ "$HTTP_STATUS" = "200" ]; then
        echo "Release v${VERSION} already exists"
        exit 1
    elif [ "$HTTP_STATUS" = "404" ]; then
        echo "Release v${VERSION} does not exist"
        exit 0
    else
        echo "Error checking release: HTTP ${HTTP_STATUS}"
        exit 2
    fi
else
    echo "Error: curl command not found"
    exit 3
fi