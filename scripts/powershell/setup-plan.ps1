#!/usr/bin/env pwsh
# Setup assessment plan for a security assessment

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# Show help if requested
if ($Help) {
    Write-Output "Usage: ./setup-plan.ps1 [-Json] [-Help]"
    Write-Output "  -Json     Output results in JSON format"
    Write-Output "  -Help     Show this help message"
    exit 0
}

# Load common functions
. "$PSScriptRoot/common.ps1"

# Get all paths and variables from common functions
$paths = Get-AssessmentPathsEnv

# Check if we're on a proper assessment branch (only for git repos)
if (-not (Test-AssessmentBranch -Branch $paths.CURRENT_BRANCH -HasGit $paths.HAS_GIT)) { 
    exit 1 
}

# Ensure the assessment directory exists
New-Item -ItemType Directory -Path $paths.ASSESSMENT_DIR -Force | Out-Null

# Copy plan template if it exists, otherwise note it or create empty file
$template = Join-Path $paths.REPO_ROOT 'templates/plan-template.md'
if (Test-Path $template) { 
    Copy-Item $template $paths.ASSESSMENT_PLAN -Force
    Write-Output "Copied plan template to $($paths.ASSESSMENT_PLAN)"
} else {
    Write-Warning "Plan template not found at $template"
    # Create a basic plan file if template doesn't exist
    New-Item -ItemType File -Path $paths.ASSESSMENT_PLAN -Force | Out-Null
}

# Output results
if ($Json) {
    $result = [PSCustomObject]@{ 
        ASSESSMENT_SPEC = $paths.ASSESSMENT_SPEC
        ASSESSMENT_PLAN = $paths.ASSESSMENT_PLAN
        SPECS_DIR = $paths.ASSESSMENT_DIR
        BRANCH = $paths.CURRENT_BRANCH
        HAS_GIT = $paths.HAS_GIT
    }
    $result | ConvertTo-Json -Compress
} else {
    Write-Output "ASSESSMENT_SPEC: $($paths.ASSESSMENT_SPEC)"
    Write-Output "ASSESSMENT_PLAN: $($paths.ASSESSMENT_PLAN)"
    Write-Output "SPECS_DIR: $($paths.ASSESSMENT_DIR)"
    Write-Output "BRANCH: $($paths.CURRENT_BRANCH)"
    Write-Output "HAS_GIT: $($paths.HAS_GIT)"
}

