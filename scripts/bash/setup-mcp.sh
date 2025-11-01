#!/usr/bin/env bash

# MCP (Model Context Protocol) Setup Script
# 
# This script sets up the MCP environment for AI-driven penetration testing.
# It installs and configures MCP servers for various security tools.
#
# Usage: ./setup-mcp.sh [OPTIONS]
#
# OPTIONS:
#   --install-all        Install all MCP servers
#   --install nmap       Install specific MCP server
#   --check              Check MCP server status
#   --start              Start all MCP servers
#   --stop               Stop all MCP servers
#   --config             Generate MCP configuration file
#   --help, -h           Show help message

set -e

# Parse command line arguments
INSTALL_ALL=false
INSTALL_TOOL=""
CHECK_STATUS=false
START_SERVERS=false
STOP_SERVERS=false
GENERATE_CONFIG=false

for arg in "$@"; do
    case "$arg" in
        --install-all)
            INSTALL_ALL=true
            ;;
        --install)
            INSTALL_ALL=true
            # Next argument is the tool name
            shift
            INSTALL_TOOL="$1"
            ;;
        --check)
            CHECK_STATUS=true
            ;;
        --start)
            START_SERVERS=true
            ;;
        --stop)
            STOP_SERVERS=true
            ;;
        --config)
            GENERATE_CONFIG=true
            ;;
        --help|-h)
            cat << 'EOF'
Usage: setup-mcp.sh [OPTIONS]

Setup MCP environment for AI-driven penetration testing.

OPTIONS:
  --install-all        Install all MCP servers
  --install <tool>     Install specific MCP server (nmap, nikto, cve, metasploit)
  --check              Check MCP server status
  --start              Start all MCP servers
  --stop               Stop all MCP servers
  --config             Generate MCP configuration file
  --help, -h           Show this help message

EXAMPLES:
  # Install all MCP servers
  ./setup-mcp.sh --install-all
  
  # Install only Nmap MCP server
  ./setup-mcp.sh --install nmap
  
  # Check server status
  ./setup-mcp.sh --check
  
  # Generate configuration file
  ./setup-mcp.sh --config
EOF
            exit 0
            ;;
        *)
            echo "ERROR: Unknown option '$arg'. Use --help for usage information." >&2
            exit 1
            ;;
    esac
done

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get repository root
eval $(get_assessment_paths)
REPO_ROOT="$REPO_ROOT"

# Configuration
MCP_DIR="$REPO_ROOT/.mcp"
CONFIG_FILE="$REPO_ROOT/mcp-config.yaml"
ENV_FILE="$REPO_ROOT/.env"
DOCKER_COMPOSE_FILE="$REPO_ROOT/docker-compose.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed and running
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker is not running. Please start Docker."
        exit 1
    fi
    
    log_success "Docker is installed and running"
}

# Check if Docker Compose is installed
check_docker_compose() {
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        log_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    log_success "Docker Compose is installed"
}

# Create MCP directory structure
create_mcp_directory() {
    log_info "Creating MCP directory structure"
    
    mkdir -p "$MCP_DIR"
    mkdir -p "$MCP_DIR/nmap"
    mkdir -p "$MCP_DIR/nikto"
    mkdir -p "$MCP_DIR/cve"
    mkdir -p "$MCP_DIR/metasploit"
    
    log_success "MCP directory structure created"
}

# Generate random tokens
generate_token() {
    openssl rand -hex 32
}

# Generate MCP configuration file
generate_config() {
    log_info "Generating MCP configuration file"
    
    # Generate tokens if they don't exist
    NMAP_TOKEN=${NMAP_MCP_TOKEN:-$(generate_token)}
    MASSCAN_TOKEN=${MASSCAN_MCP_TOKEN:-$(generate_token)}
    NIKTO_PASSWORD=${NIKTO_MCP_PASSWORD:-$(openssl rand -base64 32)}
    ZAP_API_KEY=${ZAP_API_KEY:-$(generate_token)}
    CVE_API_KEY=${CVE_API_KEY:-$(generate_token)}
    EXPLOITDB_TOKEN=${EXPLOITDB_MCP_TOKEN:-$(generate_token)}
    MSF_PASSWORD=${MSF_PASSWORD:-$(openssl rand -base64 32)}
    
    # Create configuration file
    cat > "$CONFIG_FILE" << EOF
# MCP Configuration for AI-Driven Penetration Testing
version: "1.0"
servers:
  # Network scanning tools
  nmap-mcp:
    url: "ws://localhost:8081"
    auth:
      type: "token"
      token: "\${NMAP_MCP_TOKEN}"
    timeout: 30
    retries: 3
  
  masscan-mcp:
    url: "ws://localhost:8082"
    auth:
      type: "token"
      token: "\${MASSCAN_MCP_TOKEN}"
    timeout: 60
    retries: 2
  
  # Web application security tools
  nikto-mcp:
    url: "ws://localhost:8083"
    auth:
      type: "basic"
      username: "admin"
      password: "\${NIKTO_MCP_PASSWORD}"
    timeout: 120
    retries: 3
  
  zap-mcp:
    url: "ws://localhost:8084"
    auth:
      type: "api_key"
      api_key: "\${ZAP_API_KEY}"
    timeout: 60
    retries: 3
  
  # Vulnerability databases
  cve-mcp:
    url: "ws://localhost:8085"
    auth:
      type: "none"
    timeout: 30
    retries: 3
  
  exploitdb-mcp:
    url: "ws://localhost:8086"
    auth:
      type: "token"
      token: "\${EXPLOITDB_MCP_TOKEN}"
    timeout: 30
    retries: 3
  
  # Exploitation framework
  metasploit-mcp:
    url: "ws://localhost:8087"
    auth:
      type: "password"
      username: "msf"
      password: "\${MSF_PASSWORD}"
    timeout: 300
    retries: 2

# Global settings
global:
  default_timeout: 60
  max_retries: 3
  log_level: "info"
  connection_pool_size: 10
EOF

    # Create environment file
    cat > "$ENV_FILE" << EOF
# MCP Environment Variables
# Network scanning tools
NMAP_MCP_TOKEN=$NMAP_TOKEN
MASSCAN_MCP_TOKEN=$MASSCAN_TOKEN

# Web application security tools
NIKTO_MCP_PASSWORD=$NIKTO_PASSWORD
ZAP_API_KEY=$ZAP_API_KEY

# Vulnerability databases
CVE_API_KEY=$CVE_API_KEY
EXPLOITDB_MCP_TOKEN=$EXPLOITDB_TOKEN

# Exploitation framework
MSF_PASSWORD=$MSF_PASSWORD
EOF

    log_success "MCP configuration files generated"
    log_info "Configuration file: $CONFIG_FILE"
    log_info "Environment file: $ENV_FILE"
}

# Generate Docker Compose file
generate_docker_compose() {
    log_info "Generating Docker Compose file"
    
    cat > "$DOCKER_COMPOSE_FILE" << EOF
version: '3.8'

services:
  # MCP client
  mcp-client:
    build: 
      context: .
      dockerfile: .mcp/Dockerfile
    volumes:
      - ./mcp-config.yaml:/app/mcp-config.yaml:ro
      - ./.env:/app/.env:ro
      - ./specs:/app/specs:ro
    environment:
      - ENV_FILE=/app/.env
    depends_on:
      - nmap-mcp
      - nikto-mcp
      - cve-mcp
      - metasploit-mcp
    networks:
      - mcp-network
    profiles:
      - client

  # Nmap MCP server
  nmap-mcp:
    image: mcp/nmap-server:latest
    container_name: nmap-mcp
    ports:
      - "8081:8081"
    environment:
      - TOKEN=\${NMAP_MCP_TOKEN}
    volumes:
      - /usr/bin/nmap:/usr/bin/nmap:ro
      - /etc/nmap:/etc/nmap:ro
      - ./specs:/app/specs:ro
    networks:
      - mcp-network
    restart: unless-stopped
    profiles:
      - servers

  # Masscan MCP server
  masscan-mcp:
    image: mcp/masscan-server:latest
    container_name: masscan-mcp
    ports:
      - "8082:8082"
    environment:
      - TOKEN=\${MASSCAN_MCP_TOKEN}
    volumes:
      - /usr/bin/masscan:/usr/bin/masscan:ro
      - ./specs:/app/specs:ro
    networks:
      - mcp-network
    restart: unless-stopped
    profiles:
      - servers

  # Nikto MCP server
  nikto-mcp:
    image: mcp/nikto-server:latest
    container_name: nikto-mcp
    ports:
      - "8083:8083"
    environment:
      - PASSWORD=\${NIKTO_MCP_PASSWORD}
    volumes:
      - /usr/bin/nikto:/usr/bin/nikto:ro
      - /etc/nikto:/etc/nikto:ro
      - ./specs:/app/specs:ro
    networks:
      - mcp-network
    restart: unless-stopped
    profiles:
      - servers

  # ZAP MCP server
  zap-mcp:
    image: mcp/zap-server:latest
    container_name: zap-mcp
    ports:
      - "8084:8084"
    environment:
      - API_KEY=\${ZAP_API_KEY}
    volumes:
      - ./specs:/app/specs:ro
    networks:
      - mcp-network
    restart: unless-stopped
    profiles:
      - servers

  # CVE MCP server
  cve-mcp:
    image: mcp/cve-server:latest
    container_name: cve-mcp
    ports:
      - "8085:8085"
    environment:
      - API_KEY=\${CVE_API_KEY}
    volumes:
      - ./specs:/app/specs:ro
    networks:
      - mcp-network
    restart: unless-stopped
    profiles:
      - servers

  # ExploitDB MCP server
  exploitdb-mcp:
    image: mcp/exploitdb-server:latest
    container_name: exploitdb-mcp
    ports:
      - "8086:8086"
    environment:
      - TOKEN=\${EXPLOITDB_MCP_TOKEN}
    volumes:
      - ./specs:/app/specs:ro
    networks:
      - mcp-network
    restart: unless-stopped
    profiles:
      - servers

  # Metasploit MCP server
  metasploit-mcp:
    image: mcp/metasploit-server:latest
    container_name: metasploit-mcp
    ports:
      - "8087:8087"
    environment:
      - PASSWORD=\${MSF_PASSWORD}
    volumes:
      - msf-data:/data
      - ./specs:/app/specs:ro
    networks:
      - mcp-network
    restart: unless-stopped
    profiles:
      - servers

volumes:
  msf-data:

networks:
  mcp-network:
    driver: bridge
EOF

    log_success "Docker Compose file generated"
    log_info "Docker Compose file: $DOCKER_COMPOSE_FILE"
}

# Generate Dockerfile for MCP client
generate_dockerfile() {
    log_info "Generating Dockerfile for MCP client"
    
    cat > "$MCP_DIR/Dockerfile" << EOF
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \\
    git \\
    curl \\
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Set environment variables
ENV PYTHONPATH=/app

# Create non-root user
RUN useradd --create-home --shell /bin/bash app \\
    && chown -R app:app /app
USER app

# Expose port
EXPOSE 8000

# Start command
CMD ["python", "mcp_client.py"]
EOF

    log_success "Dockerfile for MCP client generated"
}

# Generate requirements.txt for MCP client
generate_requirements() {
    log_info "Generating requirements.txt for MCP client"
    
    cat > "$MCP_DIR/requirements.txt" << EOF
# MCP Client Dependencies
mcp>=1.0.0
aiohttp>=3.8.0
websockets>=11.0.0
pyyaml>=6.0
python-dotenv>=1.0.0
asyncio>=3.4.3
requests>=2.31.0
colorama>=0.4.6
tabulate>=0.9.0
EOF

    log_success "requirements.txt for MCP client generated"
}

# Generate MCP client script
generate_mcp_client() {
    log_info "Generating MCP client script"
    
    cat > "$MCP_DIR/mcp_client.py" << 'EOF'
#!/usr/bin/env python3
"""
MCP Client for AI-Driven Penetration Testing
"""

import os
import sys
import asyncio
import yaml
import json
import logging
from typing import Dict, List, Any, Optional
from dotenv import load_dotenv
import aiohttp
import websockets
from tabulate import tabulate
import colorama
from colorama import Fore, Style

# Initialize colorama
colorama.init()

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class MCPClient:
    """MCP Client for AI-Driven Penetration Testing"""
    
    def __init__(self, config_path="mcp-config.yaml"):
        self.config = self._load_config(config_path)
        self.connections = {}
        self.session = None
    
    def _load_config(self, config_path: str) -> Dict[str, Any]:
        """Load MCP configuration from file"""
        try:
            with open(config_path, 'r') as f:
                return yaml.safe_load(f)
        except FileNotFoundError:
            logger.error(f"Configuration file not found: {config_path}")
            sys.exit(1)
        except yaml.YAMLError as e:
            logger.error(f"Error parsing configuration file: {e}")
            sys.exit(1)
    
    async def connect_all(self):
        """Connect to all configured MCP servers"""
        self.session = aiohttp.ClientSession()
        
        for server_name, server_config in self.config["servers"].items():
            try:
                await self._connect_server(server_name, server_config)
                print(f"{Fore.GREEN}✓ Connected to {server_name}{Style.RESET_ALL}")
            except Exception as e:
                print(f"{Fore.RED}✗ Failed to connect to {server_name}: {e}{Style.RESET_ALL}")
    
    async def _connect_server(self, server_name: str, server_config: Dict[str, Any]):
        """Connect to a single MCP server"""
        url = server_config["url"]
        auth = server_config.get("auth", {})
        
        # Prepare headers based on authentication type
        headers = {}
        
        if auth.get("type") == "token":
            token = os.path.expandvars(auth["token"])
            headers["Authorization"] = f"Bearer {token}"
        elif auth.get("type") == "basic":
            username = auth["username"]
            password = os.path.expandvars(auth["password"])
            # Basic auth will be handled by aiohttp
            auth = aiohttp.BasicAuth(username, password)
        elif auth.get("type") == "api_key":
            api_key = os.path.expandvars(auth["api_key"])
            headers["X-API-Key"] = api_key
        
        # Create connection
        if url.startswith("ws://") or url.startswith("wss://"):
            # WebSocket connection
            if auth.get("type") == "basic":
                # For WebSocket with basic auth, we need to include credentials in URL
                ws_url = url.replace("://", f":{password}@")
                connection = await websockets.connect(ws_url)
            else:
                connection = await websockets.connect(url, extra_headers=headers)
        else:
            # HTTP connection
            connection = await self.session.ws_connect(url, headers=headers, auth=auth if isinstance(auth, aiohttp.BasicAuth) else None)
        
        self.connections[server_name] = {
            "connection": connection,
            "config": server_config
        }
    
    async def call_tool(self, server_name: str, tool_name: str, params: Dict[str, Any]) -> Dict[str, Any]:
        """Call a tool on a specific MCP server"""
        if server_name not in self.connections:
            raise ValueError(f"Not connected to server: {server_name}")
        
        connection = self.connections[server_name]["connection"]
        timeout = self.connections[server_name]["config"].get("timeout", self.config["global"]["default_timeout"])
        max_retries = self.connections[server_name]["config"].get("retries", self.config["global"]["max_retries"])
        
        # Implement retry logic
        for attempt in range(max_retries):
            try:
                # Prepare request
                request = {
                    "jsonrpc": "2.0",
                    "id": f"{tool_name}_{attempt}",
                    "method": "tools/call",
                    "params": {
                        "name": tool_name,
                        "arguments": params
                    }
                }
                
                # Send request
                if hasattr(connection, 'send_str'):  # WebSocket
                    await connection.send_str(json.dumps(request))
                    response = await connection.recv_str()
                else:  # HTTP WebSocket
                    await connection.send_str(json.dumps(request))
                    response = await connection.receive_str()
                
                # Parse response
                result = json.loads(response)
                
                if "error" in result:
                    raise Exception(f"Tool error: {result['error']}")
                
                return result.get("result", {})
            
            except Exception as e:
                if attempt == max_retries - 1:
                    raise
                wait_time = 2 ** attempt
                logger.warning(f"Attempt {attempt + 1} failed, retrying in {wait_time}s: {e}")
                await asyncio.sleep(wait_time)
    
    async def list_tools(self, server_name: str) -> List[Dict[str, Any]]:
        """List available tools on a specific MCP server"""
        if server_name not in self.connections:
            raise ValueError(f"Not connected to server: {server_name}")
        
        connection = self.connections[server_name]["connection"]
        
        # Prepare request
        request = {
            "jsonrpc": "2.0",
            "id": f"list_tools_{server_name}",
            "method": "tools/list",
            "params": {}
        }
        
        # Send request
        if hasattr(connection, 'send_str'):  # WebSocket
            await connection.send_str(json.dumps(request))
            response = await connection.recv_str()
        else:  # HTTP WebSocket
            await connection.send_str(json.dumps(request))
            response = await connection.receive_str()
        
        # Parse response
        result = json.loads(response)
        
        if "error" in result:
            raise Exception(f"List tools error: {result['error']}")
        
        return result.get("result", {}).get("tools", [])
    
    async def close_all(self):
        """Close all connections"""
        for server_name, conn_info in self.connections.items():
            try:
                connection = conn_info["connection"]
                if hasattr(connection, 'close'):  # WebSocket
                    await connection.close()
                elif hasattr(connection, 'close'):  # HTTP WebSocket
                    await connection.close()
                print(f"{Fore.GREEN}✓ Closed connection to {server_name}{Style.RESET_ALL}")
            except Exception as e:
                print(f"{Fore.YELLOW}⚠ Error closing connection to {server_name}: {e}{Style.RESET_ALL}")
        
        if self.session:
            await self.session.close()
    
    async def interactive_mode(self):
        """Interactive mode for testing MCP tools"""
        print(f"{Fore.CYAN}MCP Interactive Mode{Style.RESET_ALL}")
        print("Type 'help' for available commands, 'quit' to exit")
        
        while True:
            try:
                command = input(f"{Fore.YELLOW}mcp>{Style.RESET_ALL} ").strip()
                
                if command.lower() in ['quit', 'exit', 'q']:
                    break
                
                if command.lower() == 'help':
                    self._show_help()
                    continue
                
                if command.lower() == 'servers':
                    self._show_servers()
                    continue
                
                if command.lower().startswith('list '):
                    server_name = command[5:].strip()
                    if server_name in self.connections:
                        try:
                            tools = await self.list_tools(server_name)
                            print(f"{Fore.CYAN}Available tools on {server_name}:{Style.RESET_ALL}")
                            for tool in tools:
                                print(f"  - {tool.get('name', 'Unknown')}: {tool.get('description', 'No description')}")
                        except Exception as e:
                            print(f"{Fore.RED}Error listing tools: {e}{Style.RESET_ALL}")
                    else:
                        print(f"{Fore.RED}Unknown server: {server_name}{Style.RESET_ALL}")
                    continue
                
                if command.lower().startswith('call '):
                    parts = command[5:].split(' ', 2)
                    if len(parts) < 2:
                        print(f"{Fore.RED}Usage: call <server> <tool> [params]{Style.RESET_ALL}")
                        continue
                    
                    server_name = parts[0]
                    tool_name = parts[1]
                    params = {}
                    
                    if len(parts) > 2:
                        try:
                            params = json.loads(parts[2])
                        except json.JSONDecodeError:
                            print(f"{Fore.RED}Invalid JSON parameters{Style.RESET_ALL}")
                            continue
                    
                    if server_name in self.connections:
                        try:
                            result = await self.call_tool(server_name, tool_name, params)
                            print(f"{Fore.GREEN}Result:{Style.RESET_ALL}")
                            print(json.dumps(result, indent=2))
                        except Exception as e:
                            print(f"{Fore.RED}Error calling tool: {e}{Style.RESET_ALL}")
                    else:
                        print(f"{Fore.RED}Unknown server: {server_name}{Style.RESET_ALL}")
                    continue
                
                print(f"{Fore.RED}Unknown command. Type 'help' for available commands{Style.RESET_ALL}")
            
            except KeyboardInterrupt:
                break
            except EOFError:
                break
    
    def _show_help(self):
        """Show help information"""
        print(f"{Fore.CYAN}Available commands:{Style.RESET_ALL}")
        print("  help              - Show this help message")
        print("  servers           - List connected servers")
        print("  list <server>     - List available tools on a server")
        print("  call <server> <tool> [params] - Call a tool with optional JSON parameters")
        print("  quit, exit, q    - Exit interactive mode")
    
    def _show_servers(self):
        """Show connected servers"""
        print(f"{Fore.CYAN}Connected servers:{Style.RESET_ALL}")
        for server_name in self.connections:
            status = f"{Fore.GREEN}Connected{Style.RESET_ALL}"
            print(f"  - {server_name}: {status}")

async def main():
    """Main function"""
    if len(sys.argv) > 1 and sys.argv[1] == "interactive":
        client = MCPClient()
        try:
            await client.connect_all()
            await client.interactive_mode()
        finally:
            await client.close_all()
    else:
        print("Usage: python mcp_client.py interactive")
        sys.exit(1)

if __name__ == "__main__":
    asyncio.run(main())
EOF

    log_success "MCP client script generated"
}

# Install MCP servers
install_mcp_servers() {
    log_info "Installing MCP servers"
    
    # Check if we're installing a specific tool
    if [ -n "$INSTALL_TOOL" ]; then
        case "$INSTALL_TOOL" in
            nmap)
                log_info "Installing Nmap MCP server"
                docker pull mcp/nmap-server:latest
                ;;
            nikto)
                log_info "Installing Nikto MCP server"
                docker pull mcp/nikto-server:latest
                ;;
            cve)
                log_info "Installing CVE MCP server"
                docker pull mcp/cve-server:latest
                ;;
            metasploit)
                log_info "Installing Metasploit MCP server"
                docker pull mcp/metasploit-server:latest
                ;;
            *)
                log_error "Unknown tool: $INSTALL_TOOL"
                log_info "Available tools: nmap, nikto, cve, metasploit"
                exit 1
                ;;
        esac
        log_success "MCP server for $INSTALL_TOOL installed"
    else
        # Install all MCP servers
        log_info "Installing all MCP servers"
        
        docker pull mcp/nmap-server:latest
        docker pull mcp/masscan-server:latest
        docker pull mcp/nikto-server:latest
        docker pull mcp/zap-server:latest
        docker pull mcp/cve-server:latest
        docker pull mcp/exploitdb-server:latest
        docker pull mcp/metasploit-server:latest
        
        log_success "All MCP servers installed"
    fi
}

# Start MCP servers
start_mcp_servers() {
    log_info "Starting MCP servers"
    
    if [ -f "$DOCKER_COMPOSE_FILE" ]; then
        # Use Docker Compose if available
        if command -v docker-compose &> /dev/null; then
            docker-compose -f "$DOCKER_COMPOSE_FILE" --profile servers up -d
        else
            docker compose -f "$DOCKER_COMPOSE_FILE" --profile servers up -d
        fi
        log_success "MCP servers started with Docker Compose"
    else
        log_error "Docker Compose file not found. Run with --config first."
        exit 1
    fi
}

# Stop MCP servers
stop_mcp_servers() {
    log_info "Stopping MCP servers"
    
    if [ -f "$DOCKER_COMPOSE_FILE" ]; then
        # Use Docker Compose if available
        if command -v docker-compose &> /dev/null; then
            docker-compose -f "$DOCKER_COMPOSE_FILE" --profile servers down
        else
            docker compose -f "$DOCKER_COMPOSE_FILE" --profile servers down
        fi
        log_success "MCP servers stopped"
    else
        log_error "Docker Compose file not found. Run with --config first."
        exit 1
    fi
}

# Check MCP server status
check_mcp_status() {
    log_info "Checking MCP server status"
    
    # Check Docker containers
    if command -v docker &> /dev/null; then
        echo "Docker containers:"
        docker ps --filter "name=mcp" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    fi
    
    # Check if ports are open
    echo ""
    echo "Port status:"
    ports=("8081" "8082" "8083" "8084" "8085" "8086" "8087")
    servers=("nmap-mcp" "masscan-mcp" "nikto-mcp" "zap-mcp" "cve-mcp" "exploitdb-mcp" "metasploit-mcp")
    
    for i in "${!ports[@]}"; do
        port="${ports[$i]}"
        server="${servers[$i]}"
        
        if nc -z localhost "$port" 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} Port $port ($server) is open"
        else
            echo -e "  ${RED}✗${NC} Port $port ($server) is closed"
        fi
    done
}

# Main execution
main() {
    # Check prerequisites
    check_docker
    check_docker_compose
    
    # Create MCP directory structure
    create_mcp_directory
    
    # Generate configuration files
    if [ "$GENERATE_CONFIG" = true ] || [ "$INSTALL_ALL" = true ]; then
        generate_config
        generate_docker_compose
        generate_dockerfile
        generate_requirements
        generate_mcp_client
    fi
    
    # Install MCP servers
    if [ "$INSTALL_ALL" = true ]; then
        install_mcp_servers
    fi
    
    # Start MCP servers
    if [ "$START_SERVERS" = true ]; then
        start_mcp_servers
    fi
    
    # Stop MCP servers
    if [ "$STOP_SERVERS" = true ]; then
        stop_mcp_servers
    fi
    
    # Check status
    if [ "$CHECK_STATUS" = true ]; then
        check_mcp_status
    fi
    
    # If no specific action was requested, show help
    if [ "$INSTALL_ALL" = false ] && [ "$CHECK_STATUS" = false ] && [ "$START_SERVERS" = false ] && [ "$STOP_SERVERS" = false ] && [ "$GENERATE_CONFIG" = false ]; then
        echo "No action specified. Use --help for usage information."
        exit 1
    fi
}

# Run main function
main