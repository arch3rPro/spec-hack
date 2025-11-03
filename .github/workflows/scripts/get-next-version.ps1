# Get next version for Spec-Hack (PowerShell version)
# This script reads the current version from pyproject.toml and optionally bumps it

param(
    [switch]$BumpPatch,
    [switch]$BumpMinor,
    [switch]$BumpMajor
)

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ScriptDir))

# Read pyproject.toml
$TomlPath = "$RepoRoot\pyproject.toml"
if (-not (Test-Path $TomlPath)) {
    Write-Error "pyproject.toml not found at $TomlPath"
    exit 1
}

$TomlContent = Get-Content -Path $TomlPath -Raw

# Extract current version
if ($TomlContent -match 'version\s*=\s*"([^"]+)"') {
    $CurrentVersion = $matches[1]
} else {
    Write-Error "Could not find version in pyproject.toml"
    exit 1
}

# Parse version components
if ($CurrentVersion -match '^(\d+)\.(\d+)\.(\d+)$') {
    $Major = [int]$matches[1]
    $Minor = [int]$matches[2]
    $Patch = [int]$matches[3]
} else {
    Write-Error "Invalid version format: $CurrentVersion. Expected format: X.Y.Z"
    exit 1
}

# Bump version if requested
if ($BumpPatch -or $BumpMinor -or $BumpMajor) {
    if ($BumpMajor) {
        $Major += 1
        $Minor = 0
        $Patch = 0
    } elseif ($BumpMinor) {
        $Minor += 1
        $Patch = 0
    } else { # BumpPatch
        $Patch += 1
    }
    
    $NewVersion = "$Major.$Minor.$Patch"
    
    # Update pyproject.toml
    $UpdatedContent = $TomlContent -replace "version\s*=\s*`"$CurrentVersion`"", "version = `"$NewVersion`""
    Set-Content -Path $TomlPath -Value $UpdatedContent -NoNewline
    
    Write-Output $NewVersion
} else {
    Write-Output $CurrentVersion
}