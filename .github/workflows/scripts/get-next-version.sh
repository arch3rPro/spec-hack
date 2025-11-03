#!/bin/bash
# Get the next semantic version for the release

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Get current version from pyproject.toml
cd "$REPO_ROOT"
CURRENT_VERSION=$(python "$REPO_ROOT/.github/workflows/scripts/get_version.py")

# Check if we should bump the version
if [ "$1" = "--bump-patch" ]; then
    # Extract version components
    IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"
    MAJOR=${VERSION_PARTS[0]}
    MINOR=${VERSION_PARTS[1]}
    PATCH=${VERSION_PARTS[2]}
    
    # Increment patch version
    PATCH=$((PATCH + 1))
    
    # Construct new version
    NEXT_VERSION="${MAJOR}.${MINOR}.${PATCH}"
else
    # Just return current version
    NEXT_VERSION="$CURRENT_VERSION"
fi

echo "$NEXT_VERSION"