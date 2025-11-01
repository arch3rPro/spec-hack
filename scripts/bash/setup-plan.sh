#!/usr/bin/env bash

set -e

# Parse command line arguments
JSON_MODE=false
ARGS=()

for arg in "$@"; do
    case "$arg" in
        --json) 
            JSON_MODE=true 
            ;;
        --help|-h) 
            echo "Usage: $0 [--json]"
            echo "  --json    Output results in JSON format"
            echo "  --help    Show this help message"
            exit 0 
            ;;
        *) 
            ARGS+=("$arg") 
            ;;
    esac
done

# Get script directory and load common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get all paths and variables from common functions
eval $(get_assessment_paths)

# Check if we're on a proper assessment branch (only for git repos)
check_assessment_branch "$CURRENT_BRANCH" "$HAS_GIT" || exit 1

# Ensure the assessment directory exists
mkdir -p "$ASSESSMENT_DIR"

# Copy plan template if it exists
TEMPLATE="$REPO_ROOT/templates/plan-template.md"
if [[ -f "$TEMPLATE" ]]; then
    cp "$TEMPLATE" "$ASSESSMENT_PLAN"
    echo "Copied plan template to $ASSESSMENT_PLAN"
else
    echo "Warning: Plan template not found at $TEMPLATE"
    # Create a basic plan file if template doesn't exist
    touch "$ASSESSMENT_PLAN"
fi

# Output results
if $JSON_MODE; then
    printf '{"ASSESSMENT_SPEC":"%s","ASSESSMENT_PLAN":"%s","SPECS_DIR":"%s","BRANCH":"%s","HAS_GIT":"%s"}\n' \
        "$ASSESSMENT_SPEC" "$ASSESSMENT_PLAN" "$ASSESSMENT_DIR" "$CURRENT_BRANCH" "$HAS_GIT"
else
    echo "ASSESSMENT_SPEC: $ASSESSMENT_SPEC"
    echo "ASSESSMENT_PLAN: $ASSESSMENT_PLAN" 
    echo "SPECS_DIR: $ASSESSMENT_DIR"
    echo "BRANCH: $CURRENT_BRANCH"
    echo "HAS_GIT: $HAS_GIT"
fi

