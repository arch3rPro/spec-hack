#!/bin/bash
# Create release packages for Spec-Hack templates
# This script generates agent-specific and script-specific zip archives

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Version info
VERSION="${1:-$(cd "$REPO_ROOT" && python -c "import tomllib; print(tomllib.load(open('pyproject.toml', 'rb'))['project']['version'])")}"
echo -e "${GREEN}Creating packages for version ${VERSION}${NC}"

# Output directory
OUTPUT_DIR="$REPO_ROOT/dist"
mkdir -p "$OUTPUT_DIR"

# All supported agents (matching AGENT_CONFIG in src/spechack_cli/__init__.py)
ALL_AGENTS=(
    "copilot"
    "claude"
    "gemini"
    "cursor-agent"
    "qwen"
    "opencode"
    "codex"
    "windsurf"
    "kilocode"
    "auggie"
    "codebuddy"
    "roo"
    "q"
    "amp"
)

# All supported script types
ALL_SCRIPTS=(
    "sh"
    "ps"
)

# Function to build a variant package
build_variant() {
    local agent="$1"
    local script="$2"
    local package_name="spechack-template-${agent}-${script}-${VERSION}.zip"
    local temp_dir=$(mktemp -d)
    
    echo -e "${YELLOW}Building package: ${package_name}${NC}"
    
    # Create base directory structure
    mkdir -p "$temp_dir/memory"
    mkdir -p "$temp_dir/scripts"
    
    # Copy base files
    cp -r "$REPO_ROOT/memory/"* "$temp_dir/memory/" 2>/dev/null || true
    
    # Copy script files based on script type
    if [ "$script" = "sh" ]; then
        mkdir -p "$temp_dir/scripts/bash"
        cp -r "$REPO_ROOT/scripts/bash/"* "$temp_dir/scripts/bash/"
    elif [ "$script" = "ps" ]; then
        mkdir -p "$temp_dir/scripts/powershell"
        cp -r "$REPO_ROOT/scripts/powershell/"* "$temp_dir/scripts/powershell/"
    fi
    
    # Create agent-specific directory and commands
    local agent_dir=""
    case "$agent" in
        "copilot")
            agent_dir=".github"
            mkdir -p "$temp_dir/$agent_dir/prompts"
            ;;
        "claude")
            agent_dir=".claude"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
        "gemini")
            agent_dir=".gemini"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
        "cursor-agent")
            agent_dir=".cursor"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
        "qwen")
            agent_dir=".qwen"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
        "opencode")
            agent_dir=".opencode"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
        "codex")
            agent_dir=".codex"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
        "windsurf")
            agent_dir=".windsurf"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
        "kilocode")
            agent_dir=".kilocode"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
        "auggie")
            agent_dir=".augment"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
        "codebuddy")
            agent_dir=".codebuddy"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
        "roo")
            agent_dir=".roo"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
        "q")
            agent_dir=".amazonq"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
        "amp")
            agent_dir=".agents"
            mkdir -p "$temp_dir/$agent_dir/commands"
            ;;
    esac
    
    # Generate agent-specific commands
    generate_commands "$agent" "$script" "$temp_dir/$agent_dir"
    
    # Copy VS Code settings for agents that need it
    if [ "$agent" = "copilot" ]; then
        mkdir -p "$temp_dir/$agent_dir"
        cp "$REPO_ROOT/templates/vscode-settings.json" "$temp_dir/$agent_dir/" 2>/dev/null || true
    fi
    
    # Create the zip package
    cd "$temp_dir"
    zip -r "$OUTPUT_DIR/$package_name" .
    
    # Clean up
    cd "$REPO_ROOT"
    rm -rf "$temp_dir"
    
    echo -e "${GREEN}✓ Created ${package_name}${NC}"
}

# Function to generate agent-specific commands
generate_commands() {
    local agent="$1"
    local script="$2"
    local output_dir="$3"
    
    # Determine file extension and format based on agent
    local file_ext="md"
    local script_path=""
    local args_format="$ARGUMENTS"
    
    case "$agent" in
        "gemini")
            file_ext="toml"
            args_format="{{args}}"
            ;;
        "copilot")
            file_ext="prompt.md"
            ;;
    esac
    
    # Set script path based on script type
    if [ "$script" = "sh" ]; then
        script_path="scripts/bash"
    elif [ "$script" = "ps" ]; then
        script_path="scripts/powershell"
    fi
    
    # Process each command template
    for template_file in "$REPO_ROOT/templates/commands"/*.md; do
        if [ -f "$template_file" ]; then
            local template_name=$(basename "$template_file" .md)
            local output_file="$output_dir/${template_name}.${file_ext}"
            
            # Extract YAML frontmatter
            local frontmatter=$(sed -n '1,/^---$/p' "$template_file" | head -n -1)
            local content=$(sed -n '/^---$/,$p' "$template_file" | tail -n +2)
            
            # Get script path from frontmatter
            local script_cmd=""
            if [ "$script" = "sh" ]; then
                script_cmd=$(echo "$frontmatter" | grep "sh:" | sed 's/.*sh: *//')
            elif [ "$script" = "ps" ]; then
                script_cmd=$(echo "$frontmatter" | grep "ps:" | sed 's/.*ps: *//')
            fi
            
            # Replace placeholders
            local processed_content="$content"
            processed_content="${processed_content//\{SCRIPT\}/$script_cmd}"
            processed_content="${processed_content//\{ARGS\}/$args_format}"
            processed_content="${processed_content//__AGENT__/$agent}"
            
            # Rewrite paths to be relative to the installation
            processed_content=$(echo "$processed_content" | sed 's|memory/|.spechack/memory/|g')
            processed_content=$(echo "$processed_content" | sed "s|$script_path/|.spechack/$script_path/|g")
            
            # Write the processed content
            echo "$processed_content" > "$output_file"
        fi
    done
}

# Main execution
echo -e "${GREEN}Starting Spec-Hack template packaging...${NC}"

# Build all variants
for agent in "${ALL_AGENTS[@]}"; do
    for script in "${ALL_SCRIPTS[@]}"; do
        build_variant "$agent" "$script"
    done
done

echo -e "${GREEN}All packages created successfully in ${OUTPUT_DIR}${NC}"

# List created packages
echo -e "${YELLOW}Created packages:${NC}"
ls -la "$OUTPUT_DIR"/spechack-template-*-${VERSION}.zip