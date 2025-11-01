#!/usr/bin/env python3
"""
AI-Driven Penetration Testing with MCP Integration
This script provides AI-driven penetration testing capabilities using MCP tools.
"""

import os
import sys
import json
import yaml
import asyncio
import argparse
import logging
from typing import Dict, List, Any, Optional, Tuple
from pathlib import Path
from datetime import datetime
import re

# Add the parent directory to the path to import common modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

try:
    from mcp_client import MCPClient
except ImportError:
    print("Error: MCP client not found. Please ensure the MCP client is properly installed.")
    sys.exit(1)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('ai_penetration_testing.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

class AIPenetrationTesting:
    """AI-Driven Penetration Testing with MCP Integration"""
    
    def __init__(self, config_path: str = "mcp-config.yaml"):
        self.mcp_client = MCPClient(config_path)
        self.assessment_plan = {}
        self.results = {}
        self.current_phase = ""
        self.target = ""
        
    async def initialize(self, assessment_plan_path: str):
        """Initialize with an assessment plan"""
        try:
            with open(assessment_plan_path, 'r') as f:
                self.assessment_plan = yaml.safe_load(f)
            
            # Extract target from assessment plan
            self.target = self.assessment_plan.get('target', {}).get('url', '')
            if not self.target:
                logger.error("No target found in assessment plan")
                return False
            
            logger.info(f"Initialized with assessment plan for target: {self.target}")
            return True
        except Exception as e:
            logger.error(f"Error loading assessment plan: {e}")
            return False
    
    async def run_reconnaissance(self) -> Dict[str, Any]:
        """Run reconnaissance phase using MCP tools"""
        logger.info("Starting reconnaissance phase")
        self.current_phase = "reconnaissance"
        
        results = {
            "phase": "reconnaissance",
            "timestamp": datetime.now().isoformat(),
            "tools_used": [],
            "findings": []
        }
        
        try:
            # Connect to MCP servers
            await self.mcp_client.connect_all()
            
            # Use Nmap for network scanning
            if "nmap-mcp" in self.mcp_client.connections:
                logger.info("Running Nmap scan")
                results["tools_used"].append("nmap")
                
                # Extract domain from target URL
                domain = re.sub(r'https?://', '', self.target).split('/')[0]
                
                nmap_params = {
                    "target": domain,
                    "options": "-sS -sV -O -A"
                }
                
                nmap_result = await self.mcp_client.call_tool("nmap-mcp", "scan", nmap_params)
                results["findings"].append({
                    "tool": "nmap",
                    "result": nmap_result
                })
            
            # Use Masscan for fast port scanning
            if "masscan-mcp" in self.mcp_client.connections:
                logger.info("Running Masscan")
                results["tools_used"].append("masscan")
                
                domain = re.sub(r'https?://', '', self.target).split('/')[0]
                
                masscan_params = {
                    "target": domain,
                    "ports": "1-65535",
                    "rate": "1000"
                }
                
                masscan_result = await self.mcp_client.call_tool("masscan-mcp", "scan", masscan_params)
                results["findings"].append({
                    "tool": "masscan",
                    "result": masscan_result
                })
            
            logger.info("Reconnaissance phase completed")
            return results
            
        except Exception as e:
            logger.error(f"Error during reconnaissance: {e}")
            results["error"] = str(e)
            return results
    
    async def run_vulnerability_scanning(self) -> Dict[str, Any]:
        """Run vulnerability scanning phase using MCP tools"""
        logger.info("Starting vulnerability scanning phase")
        self.current_phase = "vulnerability_scanning"
        
        results = {
            "phase": "vulnerability_scanning",
            "timestamp": datetime.now().isoformat(),
            "tools_used": [],
            "findings": []
        }
        
        try:
            # Use Nikto for web vulnerability scanning
            if "nikto-mcp" in self.mcp_client.connections:
                logger.info("Running Nikto scan")
                results["tools_used"].append("nikto")
                
                nikto_params = {
                    "target": self.target,
                    "options": "-Tuning 9"
                }
                
                nikto_result = await self.mcp_client.call_tool("nikto-mcp", "scan", nikto_params)
                results["findings"].append({
                    "tool": "nikto",
                    "result": nikto_result
                })
            
            # Use ZAP for comprehensive web application security testing
            if "zap-mcp" in self.mcp_client.connections:
                logger.info("Running ZAP scan")
                results["tools_used"].append("zap")
                
                zap_params = {
                    "target": self.target,
                    "scan_type": "active"
                }
                
                zap_result = await self.mcp_client.call_tool("zap-mcp", "scan", zap_params)
                results["findings"].append({
                    "tool": "zap",
                    "result": zap_result
                })
            
            logger.info("Vulnerability scanning phase completed")
            return results
            
        except Exception as e:
            logger.error(f"Error during vulnerability scanning: {e}")
            results["error"] = str(e)
            return results
    
    async def run_vulnerability_analysis(self) -> Dict[str, Any]:
        """Run vulnerability analysis phase using MCP tools"""
        logger.info("Starting vulnerability analysis phase")
        self.current_phase = "vulnerability_analysis"
        
        results = {
            "phase": "vulnerability_analysis",
            "timestamp": datetime.now().isoformat(),
            "tools_used": [],
            "findings": []
        }
        
        try:
            # Use CVE database to analyze vulnerabilities
            if "cve-mcp" in self.mcp_client.connections:
                logger.info("Querying CVE database")
                results["tools_used"].append("cve")
                
                # Extract service information from previous phases
                services = []
                if "reconnaissance" in self.results:
                    for finding in self.results["reconnaissance"].get("findings", []):
                        if finding.get("tool") == "nmap" and "services" in finding.get("result", {}):
                            services.extend(finding["result"]["services"])
                
                for service in services:
                    service_name = service.get("name", "")
                    service_version = service.get("version", "")
                    
                    if service_name and service_version:
                        cve_params = {
                            "service": service_name,
                            "version": service_version
                        }
                        
                        cve_result = await self.mcp_client.call_tool("cve-mcp", "search", cve_params)
                        results["findings"].append({
                            "tool": "cve",
                            "service": service_name,
                            "version": service_version,
                            "result": cve_result
                        })
            
            # Use ExploitDB to find exploits
            if "exploitdb-mcp" in self.mcp_client.connections:
                logger.info("Querying ExploitDB")
                results["tools_used"].append("exploitdb")
                
                # Extract vulnerabilities from previous phases
                vulnerabilities = []
                if "vulnerability_scanning" in self.results:
                    for finding in self.results["vulnerability_scanning"].get("findings", []):
                        if finding.get("tool") == "nikto" and "vulnerabilities" in finding.get("result", {}):
                            vulnerabilities.extend(finding["result"]["vulnerabilities"])
                        elif finding.get("tool") == "zap" and "alerts" in finding.get("result", {}):
                            for alert in finding["result"]["alerts"]:
                                if "risk" in alert and alert["risk"] in ["High", "Critical"]:
                                    vulnerabilities.append(alert)
                
                for vuln in vulnerabilities[:10]:  # Limit to top 10 vulnerabilities
                    vuln_name = vuln.get("name", "") or vuln.get("pluginid", "")
                    
                    if vuln_name:
                        exploitdb_params = {
                            "search_term": vuln_name
                        }
                        
                        exploitdb_result = await self.mcp_client.call_tool("exploitdb-mcp", "search", exploitdb_params)
                        results["findings"].append({
                            "tool": "exploitdb",
                            "vulnerability": vuln_name,
                            "result": exploitdb_result
                        })
            
            logger.info("Vulnerability analysis phase completed")
            return results
            
        except Exception as e:
            logger.error(f"Error during vulnerability analysis: {e}")
            results["error"] = str(e)
            return results
    
    async def run_exploitation(self) -> Dict[str, Any]:
        """Run exploitation phase using MCP tools"""
        logger.info("Starting exploitation phase")
        self.current_phase = "exploitation"
        
        results = {
            "phase": "exploitation",
            "timestamp": datetime.now().isoformat(),
            "tools_used": [],
            "findings": []
        }
        
        try:
            # Use Metasploit for exploitation
            if "metasploit-mcp" in self.mcp_client.connections:
                logger.info("Running Metasploit")
                results["tools_used"].append("metasploit")
                
                # Extract exploits from previous phases
                exploits = []
                if "vulnerability_analysis" in self.results:
                    for finding in self.results["vulnerability_analysis"].get("findings", []):
                        if finding.get("tool") == "exploitdb" and "results" in finding.get("result", {}):
                            exploits.extend(finding["result"]["results"])
                
                for exploit in exploits[:5]:  # Limit to top 5 exploits
                    exploit_id = exploit.get("id", "")
                    exploit_path = exploit.get("path", "")
                    
                    if exploit_id or exploit_path:
                        metasploit_params = {
                            "exploit": exploit_path or exploit_id,
                            "target": self.target,
                            "options": {}
                        }
                        
                        metasploit_result = await self.mcp_client.call_tool("metasploit-mcp", "exploit", metasploit_params)
                        results["findings"].append({
                            "tool": "metasploit",
                            "exploit": exploit_path or exploit_id,
                            "result": metasploit_result
                        })
            
            logger.info("Exploitation phase completed")
            return results
            
        except Exception as e:
            logger.error(f"Error during exploitation: {e}")
            results["error"] = str(e)
            return results
    
    async def run_full_assessment(self) -> Dict[str, Any]:
        """Run a full security assessment"""
        logger.info("Starting full security assessment")
        
        # Run all phases
        self.results["reconnaissance"] = await self.run_reconnaissance()
        self.results["vulnerability_scanning"] = await self.run_vulnerability_scanning()
        self.results["vulnerability_analysis"] = await self.run_vulnerability_analysis()
        self.results["exploitation"] = await self.run_exploitation()
        
        # Generate summary
        summary = self.generate_summary()
        self.results["summary"] = summary
        
        logger.info("Full security assessment completed")
        return self.results
    
    def generate_summary(self) -> Dict[str, Any]:
        """Generate a summary of the assessment results"""
        summary = {
            "target": self.target,
            "assessment_date": datetime.now().isoformat(),
            "phases_completed": list(self.results.keys()),
            "tools_used": set(),
            "vulnerabilities_found": 0,
            "high_risk_vulnerabilities": 0,
            "exploits_available": 0
        }
        
        # Collect tools used
        for phase, results in self.results.items():
            if "tools_used" in results:
                summary["tools_used"].update(results["tools_used"])
        
        summary["tools_used"] = list(summary["tools_used"])
        
        # Count vulnerabilities and exploits
        for phase, results in self.results.items():
            if phase == "vulnerability_scanning":
                for finding in results.get("findings", []):
                    if finding.get("tool") == "nikto" and "vulnerabilities" in finding.get("result", {}):
                        summary["vulnerabilities_found"] += len(finding["result"]["vulnerabilities"])
                    elif finding.get("tool") == "zap" and "alerts" in finding.get("result", {}):
                        for alert in finding["result"]["alerts"]:
                            summary["vulnerabilities_found"] += 1
                            if alert.get("risk") in ["High", "Critical"]:
                                summary["high_risk_vulnerabilities"] += 1
            
            elif phase == "vulnerability_analysis":
                for finding in results.get("findings", []):
                    if finding.get("tool") == "exploitdb" and "results" in finding.get("result", {}):
                        summary["exploits_available"] += len(finding["result"]["results"])
        
        return summary
    
    def save_results(self, output_path: str):
        """Save assessment results to a file"""
        try:
            with open(output_path, 'w') as f:
                json.dump(self.results, f, indent=2)
            logger.info(f"Results saved to {output_path}")
        except Exception as e:
            logger.error(f"Error saving results: {e}")
    
    async def cleanup(self):
        """Clean up resources"""
        await self.mcp_client.close_all()

async def main():
    """Main function"""
    parser = argparse.ArgumentParser(description="AI-Driven Penetration Testing with MCP Integration")
    parser.add_argument("plan", help="Path to assessment plan file")
    parser.add_argument("-o", "--output", default="assessment_results.json", help="Output file for results")
    parser.add_argument("-p", "--phase", choices=["reconnaissance", "vulnerability_scanning", "vulnerability_analysis", "exploitation"], help="Run only a specific phase")
    parser.add_argument("-c", "--config", default="mcp-config.yaml", help="MCP configuration file")
    
    args = parser.parse_args()
    
    # Initialize AI penetration testing
    ai_pt = AIPenetrationTesting(args.config)
    
    try:
        # Initialize with assessment plan
        if not await ai_pt.initialize(args.plan):
            logger.error("Failed to initialize with assessment plan")
            return 1
        
        # Run assessment
        if args.phase:
            if args.phase == "reconnaissance":
                results = await ai_pt.run_reconnaissance()
            elif args.phase == "vulnerability_scanning":
                results = await ai_pt.run_vulnerability_scanning()
            elif args.phase == "vulnerability_analysis":
                results = await ai_pt.run_vulnerability_analysis()
            elif args.phase == "exploitation":
                results = await ai_pt.run_exploitation()
            
            ai_pt.results[args.phase] = results
        else:
            # Run full assessment
            await ai_pt.run_full_assessment()
        
        # Save results
        ai_pt.save_results(args.output)
        
        return 0
    
    except Exception as e:
        logger.error(f"Error during assessment: {e}")
        return 1
    
    finally:
        # Clean up
        await ai_pt.cleanup()

if __name__ == "__main__":
    sys.exit(asyncio.run(main()))