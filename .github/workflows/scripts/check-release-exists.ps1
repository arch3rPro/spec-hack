# Check if a release exists for Spec-Hack (PowerShell version)
# This script checks if a release with the specified version already exists

param(
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [string]$Repo = "Spec-Hack"
)

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ScriptDir))

# Validate version format
if ($Version -notmatch '^v?\d+\.\d+\.\d+$') {
    Write-Error "Invalid version format: $Version. Expected format: v1.2.3 or 1.2.3"
    exit 1
}

# Ensure version starts with 'v'
if (-not $Version.StartsWith("v")) {
    $Version = "v$Version"
}

# Get GitHub token from environment
$Token = $env:GITHUB_TOKEN
if (-not $Token) {
    Write-Error "GITHUB_TOKEN environment variable not set"
    exit 1
}

# Get repository owner from environment or default to current user
$Owner = $env:GITHUB_REPOSITORY_OWNER
if (-not $Owner) {
    Write-Error "GITHUB_REPOSITORY_OWNER environment variable not set"
    exit 1
}

# Check if release exists
$ApiUrl = "https://api.github.com/repos/$Owner/$Repo/releases/tags/$Version"

try {
    $Headers = @{
        "Authorization" = "token $Token"
        "Accept" = "application/vnd.github.v3+json"
    }
    
    $Response = Invoke-RestMethod -Uri $ApiUrl -Headers $Headers -Method Get
    
    if ($Response.tag_name -eq $Version) {
        Write-Host "Release $Version already exists" -ForegroundColor Yellow
        exit 0
    }
} catch {
    $StatusCode = $_.Exception.Response.StatusCode.value__
    
    if ($StatusCode -eq 404) {
        Write-Host "Release $Version does not exist" -ForegroundColor Green
        exit 1
    } else {
        Write-Error "Error checking release: $_"
        exit 2
    }
}