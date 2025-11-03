# Create release packages for Spec-Hack templates (PowerShell version)
# This script generates agent-specific and script-specific zip archives

param(
    [string]$Version = ""
)

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ScriptDir))

# Get version from pyproject.toml if not provided
if (-not $Version) {
    $TomlContent = Get-Content -Path "$RepoRoot\pyproject.toml" -Raw
    if ($TomlContent -match 'version\s*=\s*"([^"]+)"') {
        $Version = $matches[1]
    } else {
        Write-Error "Could not determine version from pyproject.toml"
        exit 1
    }
}

Write-Host "Creating packages for version $Version" -ForegroundColor Green

# Output directory
$OutputDir = "$RepoRoot\dist"
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# All supported agents (matching AGENT_CONFIG in src/spechack_cli/__init__.py)
$AllAgents = @(
    "copilot",
    "claude",
    "gemini",
    "cursor-agent",
    "qwen",
    "opencode",
    "codex",
    "windsurf",
    "kilocode",
    "auggie",
    "codebuddy",
    "roo",
    "q",
    "amp"
)

# All supported script types
$AllScripts = @(
    "sh",
    "ps"
)

# Function to build a variant package
function Build-Variant {
    param(
        [string]$Agent,
        [string]$Script
    )
    
    $PackageName = "spechack-template-$Agent-$Script-$Version.zip"
    $TempDir = Join-Path $env:TEMP "spechack-$Agent-$Script"
    
    Write-Host "Building package: $PackageName" -ForegroundColor Yellow
    
    # Clean up temp directory if it exists
    if (Test-Path $TempDir) {
        Remove-Item -Recurse -Force $TempDir
    }
    
    # Create base directory structure
    New-Item -ItemType Directory -Path "$TempDir\memory" | Out-Null
    New-Item -ItemType Directory -Path "$TempDir\scripts" | Out-Null
    
    # Copy base files
    if (Test-Path "$RepoRoot\memory\*") {
        Copy-Item -Path "$RepoRoot\memory\*" -Destination "$TempDir\memory\" -Recurse
    }
    
    # Copy script files based on script type
    if ($Script -eq "sh") {
        New-Item -ItemType Directory -Path "$TempDir\scripts\bash" | Out-Null
        if (Test-Path "$RepoRoot\scripts\bash\*") {
            Copy-Item -Path "$RepoRoot\scripts\bash\*" -Destination "$TempDir\scripts\bash\" -Recurse
        }
    } elseif ($Script -eq "ps") {
        New-Item -ItemType Directory -Path "$TempDir\scripts\powershell" | Out-Null
        if (Test-Path "$RepoRoot\scripts\powershell\*") {
            Copy-Item -Path "$RepoRoot\scripts\powershell\*" -Destination "$TempDir\scripts\powershell\" -Recurse
        }
    }
    
    # Create agent-specific directory and commands
    $AgentDir = ""
    switch ($Agent) {
        "copilot" {
            $AgentDir = ".github"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\prompts" | Out-Null
        }
        "claude" {
            $AgentDir = ".claude"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
        "gemini" {
            $AgentDir = ".gemini"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
        "cursor-agent" {
            $AgentDir = ".cursor"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
        "qwen" {
            $AgentDir = ".qwen"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
        "opencode" {
            $AgentDir = ".opencode"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
        "codex" {
            $AgentDir = ".codex"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
        "windsurf" {
            $AgentDir = ".windsurf"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
        "kilocode" {
            $AgentDir = ".kilocode"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
        "auggie" {
            $AgentDir = ".augment"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
        "codebuddy" {
            $AgentDir = ".codebuddy"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
        "roo" {
            $AgentDir = ".roo"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
        "q" {
            $AgentDir = ".amazonq"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
        "amp" {
            $AgentDir = ".agents"
            New-Item -ItemType Directory -Path "$TempDir\$AgentDir\commands" | Out-Null
        }
    }
    
    # Generate agent-specific commands
    Generate-Commands -Agent $Agent -Script $Script -OutputDir "$TempDir\$AgentDir"
    
    # Copy VS Code settings for agents that need it
    if ($Agent -eq "copilot") {
        New-Item -ItemType Directory -Path "$TempDir\$AgentDir" | Out-Null
        if (Test-Path "$RepoRoot\templates\vscode-settings.json") {
            Copy-Item -Path "$RepoRoot\templates\vscode-settings.json" -Destination "$TempDir\$AgentDir\"
        }
    }
    
    # Create the zip package
    Compress-Archive -Path "$TempDir\*" -DestinationPath "$OutputDir\$PackageName" -Force
    
    # Clean up
    Remove-Item -Recurse -Force $TempDir
    
    Write-Host "✓ Created $PackageName" -ForegroundColor Green
}

# Function to generate agent-specific commands
function Generate-Commands {
    param(
        [string]$Agent,
        [string]$Script,
        [string]$OutputDir
    )
    
    # Determine file extension and format based on agent
    $FileExt = "md"
    $ScriptPath = ""
    $ArgsFormat = '$ARGUMENTS'
    
    switch ($Agent) {
        "gemini" {
            $FileExt = "toml"
            $ArgsFormat = "{{args}}"
        }
        "copilot" {
            $FileExt = "prompt.md"
        }
    }
    
    # Set script path based on script type
    if ($Script -eq "sh") {
        $ScriptPath = "scripts/bash"
    } elseif ($Script -eq "ps") {
        $ScriptPath = "scripts/powershell"
    }
    
    # Process each command template
    Get-ChildItem "$RepoRoot\templates\commands\*.md" | ForEach-Object {
        $TemplateFile = $_
        $TemplateName = $_.BaseName
        $OutputFile = "$OutputDir\$TemplateName.$FileExt"
        
        # Read the template file
        $Content = Get-Content -Path $TemplateFile -Raw
        
        # Extract YAML frontmatter
        if ($Content -match '(?s)^(---\s*\n.*?\n---\s*\n)(.*)$') {
            $Frontmatter = $matches[1]
            $CommandContent = $matches[2]
        } else {
            $Frontmatter = ""
            $CommandContent = $Content
        }
        
        # Get script path from frontmatter
        $ScriptCmd = ""
        if ($Script -eq "sh" -and $Frontmatter -match 'sh:\s*([^\n\r]+)') {
            $ScriptCmd = $matches[1].Trim()
        } elseif ($Script -eq "ps" -and $Frontmatter -match 'ps:\s*([^\n\r]+)') {
            $ScriptCmd = $matches[1].Trim()
        }
        
        # Replace placeholders
        $ProcessedContent = $CommandContent
        $ProcessedContent = $ProcessedContent -replace '\{SCRIPT\}', $ScriptCmd
        $ProcessedContent = $ProcessedContent -replace '\{ARGS\}', $ArgsFormat
        $ProcessedContent = $ProcessedContent -replace '__AGENT__', $Agent
        
        # Rewrite paths to be relative to the installation
        $ProcessedContent = $ProcessedContent -replace 'memory/', '.spechack/memory/'
        $ProcessedContent = $ProcessedContent -replace "$ScriptPath/", ".spechack/$ScriptPath/"
        
        # Write the processed content
        Set-Content -Path $OutputFile -Value $ProcessedContent -NoNewline
    }
}

# Main execution
Write-Host "Starting Spec-Hack template packaging..." -ForegroundColor Green

# Build all variants
foreach ($Agent in $AllAgents) {
    foreach ($Script in $AllScripts) {
        Build-Variant -Agent $Agent -Script $Script
    }
}

Write-Host "All packages created successfully in $OutputDir" -ForegroundColor Green

# List created packages
Write-Host "Created packages:" -ForegroundColor Yellow
Get-ChildItem "$OutputDir\spechack-template-*-$Version.zip" | ForEach-Object {
    Write-Host $_.Name
}