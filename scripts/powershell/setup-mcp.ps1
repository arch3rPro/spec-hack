# MCP (Model Context Protocol) Setup Script for PowerShell
# 
# This script sets up the MCP environment for AI-driven penetration testing.
# It installs and configures MCP servers for various security tools.
#
# Usage: .\setup-mcp.ps1 [OPTIONS]
#
# OPTIONS:
#   -InstallAll          Install all MCP servers
#   -Install <tool>      Install specific MCP server
#   -Check               Check MCP server status
#   -Start               Start all MCP servers
#   -Stop                Stop all MCP servers
#   -Config              Generate MCP configuration file
#   -Help                Show help message

param(
    [switch]$InstallAll,
    [string]$Install,
    [switch]$Check,
    [switch]$Start,
    [switch]$Stop,
    [switch]$Config,
    [switch]$Help
)

# Source common functions
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "common.ps1")

# Get repository root
$RepoRoot = Get-RepoRoot

# Configuration
$McpDir = Join-Path $RepoRoot ".mcp"
$ConfigFile = Join-Path $RepoRoot "mcp-config.yaml"
$EnvFile = Join-Path $RepoRoot ".env"
$DockerComposeFile = Join-Path $RepoRoot "docker-compose.yml"

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Blue"
    Cyan = "Cyan"
    White = "White"
}

# Logging functions
function Write-LogInfo {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $Colors.Blue
}

function Write-LogSuccess {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $Colors.Green
}

function Write-LogWarning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $Colors.Yellow
}

function Write-LogError {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $Colors.Red
}

# Show help message
function Show-Help {
    Write-Host @"
Usage: .\setup-mcp.ps1 [OPTIONS]

Setup MCP environment for AI-driven penetration testing.

OPTIONS:
  -InstallAll          Install all MCP servers
  -Install <tool>      Install specific MCP server (nmap, nikto, cve, metasploit)
  -Check               Check MCP server status
  -Start               Start all MCP servers
  -Stop                Stop all MCP servers
  -Config              Generate MCP configuration file
  -Help                Show this help message

EXAMPLES:
  # Install all MCP servers
  .\setup-mcp.ps1 -InstallAll
  
  # Install only Nmap MCP server
  .\setup-mcp.ps1 -Install nmap
  
  # Check server status
  .\setup-mcp.ps1 -Check
  
  # Generate configuration file
  .\setup-mcp.ps1 -Config
"@
}

# Check if Docker is installed and running
function Test-Docker {
    try {
        $null = Get-Command docker -ErrorAction Stop
        $null = docker info 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-LogError "Docker is not running. Please start Docker."
            exit 1
        }
        Write-LogSuccess "Docker is installed and running"
    }
    catch {
        Write-LogError "Docker is not installed. Please install Docker first."
        exit 1
    }
}

# Check if Docker Compose is installed
function Test-DockerCompose {
    try {
        $null = Get-Command docker-compose -ErrorAction Stop
        Write-LogSuccess "Docker Compose is installed"
    }
    catch {
        try {
            # Check if docker compose (without hyphen) is available
            $null = docker compose version 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-LogSuccess "Docker Compose is installed"
                return
            }
        }
        catch {
            # Continue to error
        }
        
        Write-LogError "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    }
}

# Create MCP directory structure
function New-McpDirectory {
    Write-LogInfo "Creating MCP directory structure"
    
    $null = New-Item -Path $McpDir -ItemType Directory -Force
    $null = New-Item -Path (Join-Path $McpDir "nmap") -ItemType Directory -Force
    $null = New-Item -Path (Join-Path $McpDir "nikto") -ItemType Directory -Force
    $null = New-Item -Path (Join-Path $McpDir "cve") -ItemType Directory -Force
    $null = New-Item -Path (Join-Path $McpDir "metasploit") -ItemType Directory -Force
    
    Write-LogSuccess "MCP directory structure created"
}

# Generate random token
function New-RandomToken {
    $bytes = New-Object byte[] 32
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $rng.GetBytes($bytes)
    $rng.Dispose()
    return [System.BitConverter]::ToString($bytes).Replace("-", "").ToLower()
}

# Generate random password
function New-RandomPassword {
    $bytes = New-Object byte[] 24
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $rng.GetBytes($bytes)
    $rng.Dispose()
    return [System.Convert]::ToBase64String($bytes)
}

# Generate MCP configuration file
function New-McpConfig {
    Write-LogInfo "Generating MCP configuration file"
    
    # Generate tokens if they don't exist
    $NmapToken = if ($env:NMAP_MCP_TOKEN) { $env:NMAP_MCP_TOKEN } else { New-RandomToken }
    $MasscanToken = if ($env:MASSCAN_MCP_TOKEN) { $env:MASSCAN_MCP_TOKEN } else { New-RandomToken }
    $NiktoPassword = if ($env:NIKTO_MCP_PASSWORD) { $env:NIKTO_MCP_PASSWORD } else { New-RandomPassword }
    $ZapApiKey = if ($env:ZAP_API_KEY) { $env:ZAP_API_KEY } else { New-RandomToken }
    $CveApiKey = if ($env:CVE_API_KEY) { $env:CVE_API_KEY } else { New-RandomToken }
    $ExploitdbToken = if ($env:EXPLOITDB_MCP_TOKEN) { $env:EXPLOITDB_MCP_TOKEN } else { New-RandomToken }
    $MsfPassword = if ($env:MSF_PASSWORD) { $env:MSF_PASSWORD } else { New-RandomPassword }
    
    # Create configuration file
    @"
# MCP Configuration for AI-Driven Penetration Testing
version: "1.0"
servers:
  # Network scanning tools
  nmap-mcp:
    url: "ws://localhost:8081"
    auth:
      type: "token"
      token: "`${NMAP_MCP_TOKEN}"
    timeout: 30
    retries: 3
  
  masscan-mcp:
    url: "ws://localhost:8082"
    auth:
      type: "token"
      token: "`${MASSCAN_MCP_TOKEN}"
    timeout: 60
    retries: 2
  
  # Web application security tools
  nikto-mcp:
    url: "ws://localhost:8083"
    auth:
      type: "basic"
      username: "admin"
      password: "`${NIKTO_MCP_PASSWORD}"
    timeout: 120
    retries: 3
  
  zap-mcp:
    url: "ws://localhost:8084"
    auth:
      type: "api_key"
      api_key: "`${ZAP_API_KEY}"
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
      token: "`${EXPLOITDB_MCP_TOKEN}"
    timeout: 30
    retries: 3
  
  # Exploitation framework
  metasploit-mcp:
    url: "ws://localhost:8087"
    auth:
      type: "password"
      username: "msf"
      password: "`${MSF_PASSWORD}"
    timeout: 300
    retries: 2

# Global settings
global:
  default_timeout: 60
  max_retries: 3
  log_level: "info"
  connection_pool_size: 10
"@ | Out-File -FilePath $ConfigFile -Encoding UTF8
    
    # Create environment file
    @"
# MCP Environment Variables
# Network scanning tools
NMAP_MCP_TOKEN=$NmapToken
MASSCAN_MCP_TOKEN=$MasscanToken

# Web application security tools
NIKTO_MCP_PASSWORD=$NiktoPassword
ZAP_API_KEY=$ZapApiKey

# Vulnerability databases
CVE_API_KEY=$CveApiKey
EXPLOITDB_MCP_TOKEN=$ExploitdbToken

# Exploitation framework
MSF_PASSWORD=$MsfPassword
"@ | Out-File -FilePath $EnvFile -Encoding UTF8
    
    Write-LogSuccess "MCP configuration files generated"
    Write-LogInfo "Configuration file: $ConfigFile"
    Write-LogInfo "Environment file: $EnvFile"
}

# Generate Docker Compose file
function New-DockerCompose {
    Write-LogInfo "Generating Docker Compose file"
    
    @"
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
      - TOKEN=`${NMAP_MCP_TOKEN}
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
      - TOKEN=`${MASSCAN_MCP_TOKEN}
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
      - PASSWORD=`${NIKTO_MCP_PASSWORD}
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
      - API_KEY=`${ZAP_API_KEY}
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
      - API_KEY=`${CVE_API_KEY}
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
      - TOKEN=`${EXPLOITDB_MCP_TOKEN}
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
      - PASSWORD=`${MSF_PASSWORD}
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
"@ | Out-File -FilePath $DockerComposeFile -Encoding UTF8
    
    Write-LogSuccess "Docker Compose file generated"
    Write-LogInfo "Docker Compose file: $DockerComposeFile"
}

# Generate Dockerfile for MCP client
function New-Dockerfile {
    Write-LogInfo "Generating Dockerfile for MCP client"
    
    $DockerfilePath = Join-Path $McpDir "Dockerfile"
    
    @"
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
"@ | Out-File -FilePath $DockerfilePath -Encoding UTF8
    
    Write-LogSuccess "Dockerfile for MCP client generated"
}

# Generate requirements.txt for MCP client
function New-Requirements {
    Write-LogInfo "Generating requirements.txt for MCP client"
    
    $RequirementsPath = Join-Path $McpDir "requirements.txt"
    
    @"
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
"@ | Out-File -FilePath $RequirementsPath -Encoding UTF8
    
    Write-LogSuccess "requirements.txt for MCP client generated"
}

# Generate MCP client script
function New-McpClient {
    Write-LogInfo "Generating MCP client script"
    
    $McpClientPath = Join-Path $McpDir "mcp_client.py"
    
    @"
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
"@ | Out-File -FilePath $McpClientPath -Encoding UTF8
    
    Write-LogSuccess "MCP client script generated"
}

# Install MCP servers
function Install-McpServers {
    param([string]$Tool)
    
    Write-LogInfo "Installing MCP servers"
    
    if ($Tool) {
        switch ($Tool.ToLower()) {
            "nmap" {
                Write-LogInfo "Installing Nmap MCP server"
                docker pull mcp/nmap-server:latest
            }
            "nikto" {
                Write-LogInfo "Installing Nikto MCP server"
                docker pull mcp/nikto-server:latest
            }
            "cve" {
                Write-LogInfo "Installing CVE MCP server"
                docker pull mcp/cve-server:latest
            }
            "metasploit" {
                Write-LogInfo "Installing Metasploit MCP server"
                docker pull mcp/metasploit-server:latest
            }
            default {
                Write-LogError "Unknown tool: $Tool"
                Write-LogInfo "Available tools: nmap, nikto, cve, metasploit"
                exit 1
            }
        }
        Write-LogSuccess "MCP server for $Tool installed"
    }
    else {
        # Install all MCP servers
        Write-LogInfo "Installing all MCP servers"
        
        docker pull mcp/nmap-server:latest
        docker pull mcp/masscan-server:latest
        docker pull mcp/nikto-server:latest
        docker pull mcp/zap-server:latest
        docker pull mcp/cve-server:latest
        docker pull mcp/exploitdb-server:latest
        docker pull mcp/metasploit-server:latest
        
        Write-LogSuccess "All MCP servers installed"
    }
}

# Start MCP servers
function Start-McpServers {
    Write-LogInfo "Starting MCP servers"
    
    if (Test-Path $DockerComposeFile) {
        # Use Docker Compose if available
        if (Get-Command docker-compose -ErrorAction SilentlyContinue) {
            docker-compose -f $DockerComposeFile --profile servers up -d
        }
        else {
            docker compose -f $DockerComposeFile --profile servers up -d
        }
        Write-LogSuccess "MCP servers started with Docker Compose"
    }
    else {
        Write-LogError "Docker Compose file not found. Run with -Config first."
        exit 1
    }
}

# Stop MCP servers
function Stop-McpServers {
    Write-LogInfo "Stopping MCP servers"
    
    if (Test-Path $DockerComposeFile) {
        # Use Docker Compose if available
        if (Get-Command docker-compose -ErrorAction SilentlyContinue) {
            docker-compose -f $DockerComposeFile --profile servers down
        }
        else {
            docker compose -f $DockerComposeFile --profile servers down
        }
        Write-LogSuccess "MCP servers stopped"
    }
    else {
        Write-LogError "Docker Compose file not found. Run with -Config first."
        exit 1
    }
}

# Check MCP server status
function Test-McpStatus {
    Write-LogInfo "Checking MCP server status"
    
    # Check Docker containers
    if (Get-Command docker -ErrorAction SilentlyContinue) {
        Write-Host "Docker containers:"
        docker ps --filter "name=mcp" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    }
    
    # Check if ports are open
    Write-Host ""
    Write-Host "Port status:"
    $ports = @("8081", "8082", "8083", "8084", "8085", "8086", "8087")
    $servers = @("nmap-mcp", "masscan-mcp", "nikto-mcp", "zap-mcp", "cve-mcp", "exploitdb-mcp", "metasploit-mcp")
    
    for ($i = 0; $i -lt $ports.Length; $i++) {
        $port = $ports[$i]
        $server = $servers[$i]
        
        try {
            $tcpClient = New-Object System.Net.Sockets.TcpClient
            $tcpClient.Connect("localhost", [int]$port)
            $tcpClient.Close()
            Write-Host "  ✓ Port $port ($server) is open" -ForegroundColor $Colors.Green
        }
        catch {
            Write-Host "  ✗ Port $port ($server) is closed" -ForegroundColor $Colors.Red
        }
    }
}

# Main execution
function Main {
    # Show help if requested
    if ($Help) {
        Show-Help
        return
    }
    
    # Check prerequisites
    Test-Docker
    Test-DockerCompose
    
    # Create MCP directory structure
    New-McpDirectory
    
    # Generate configuration files
    if ($Config -or $InstallAll) {
        New-McpConfig
        New-DockerCompose
        New-Dockerfile
        New-Requirements
        New-McpClient
    }
    
    # Install MCP servers
    if ($InstallAll) {
        Install-McpServers -Tool $Install
    }
    
    # Start MCP servers
    if ($Start) {
        Start-McpServers
    }
    
    # Stop MCP servers
    if ($Stop) {
        Stop-McpServers
    }
    
    # Check status
    if ($Check) {
        Test-McpStatus
    }
    
    # If no specific action was requested, show help
    if (-not $InstallAll -and -not $Check -and -not $Start -and -not $Stop -and -not $Config) {
        Write-Host "No action specified. Use -Help for usage information."
        exit 1
    }
}

# Run main function
Main