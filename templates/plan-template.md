# Security Assessment Plan: [ASSESSMENT]

**Branch**: `[###-assessment-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Security assessment specification from `/specs/[###-assessment-name]/spec.md`

**Note**: This template is filled in by the `/spechack.plan` command. See `templates/commands/plan.md` for the execution workflow.

## Summary

[Extract from security assessment spec: primary security requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the security assessment. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Assessment Type**: [e.g., Web Application Penetration Test, Network Security Assessment, Red Team Engagement]  
**Target Technology**: [e.g., React/Node.js, Java/Spring, .NET Core or NEEDS CLARIFICATION]  
**Security Tools**: [e.g., Burp Suite, Nmap, Metasploit, OWASP ZAP or NEEDS CLARIFICATION]  
**MCP Tools**: [e.g., Nmap MCP, Nikto MCP, Shodan MCP, CVE MCP or NEEDS CLARIFICATION]  
**AI Automation**: [e.g., Vulnerability prioritization, exploit generation, report analysis or NEEDS CLARIFICATION]  
**Testing Framework**: [e.g., OWASP Testing Guide, NIST SP 800-115, PTES or NEEDS CLARIFICATION]  
**Target Environment**: [e.g., Production, Staging, Dedicated Test Environment or NEEDS CLARIFICATION]
**Assessment Scope**: [web/mobile/network/infrastructure - determines test structure]  
**Security Goals**: [domain-specific, e.g., identify OWASP Top 10, find critical vulnerabilities, test specific controls]  
**Constraints**: [domain-specific, e.g., no DoS testing, limited time window, specific test windows or NEEDS CLARIFICATION]  
**Scale/Scope**: [domain-specific, e.g., 10 web applications, 50 network endpoints, 5 mobile apps or NEEDS CLARIFICATION]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

[Gates determined based on constitution file]

## Project Structure

### Documentation (this assessment)

```text
specs/[###-assessment]/
├── plan.md              # This file (/spechack.plan command output)
├── research.md          # Phase 0 output (/spechack.plan command)
├── target-model.md      # Phase 1 output (/spechack.plan command)
├── methodology.md       # Phase 1 output (/spechack.plan command)
├── contracts/           # Phase 1 output (/spechack.plan command)
└── tasks.md             # Phase 2 output (/spechack.tasks command - NOT created by /spechack.plan)
```

### Security Assessment Structure (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this assessment. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/web, networks/internal, mobile/android). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Web Application Assessment (DEFAULT)
web/
├── reconnaissance/
├── vulnerability-scanning/
├── manual-testing/
└── reporting/

evidence/
├── screenshots/
├── logs/
└── proofs/

# [REMOVE IF UNUSED] Option 2: Network Security Assessment (when "network" detected)
network/
├── external-perimeter/
├── internal-segments/
└── wireless/

evidence/
├── scan-results/
├── configs/
└── topology/

# [REMOVE IF UNUSED] Option 3: Mobile Application Assessment (when "iOS/Android" detected)
mobile/
├── static-analysis/
├── dynamic-analysis/
└── api-testing/

evidence/
├── device-screenshots/
├── traffic-captures/
└── app-analysis/
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., Extended scope] | [current security need] | [why limited scope insufficient] |
| [e.g., Advanced testing] | [specific security requirement] | [why basic testing insufficient] |
