# Security Assessment Specification: [ASSESSMENT NAME]

**Assessment Branch**: `[###-assessment-name]`  
**Created**: [DATE]  
**Status**: Draft  
**Input**: Target description: "$ARGUMENTS"

## Security Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: Security scenarios should be PRIORITIZED as attack vectors ordered by risk.
  Each scenario must be INDEPENDENTLY TESTABLE - meaning if you execute just ONE of them,
  you should still have a viable security test that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each scenario, where P1 is the most critical.
  Think of each scenario as a standalone security test that can be:
  - Executed independently
  - Validated independently
  - Reported independently
  - Demonstrated to stakeholders independently
-->

### Security Scenario 1 - [Brief Title] (Priority: P1)

[Describe this security scenario in plain language - e.g., "SQL Injection in Login Form"]

**Why this priority**: [Explain the security impact and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently - e.g., "Can be fully tested by [specific tool/technique] and identifies [specific vulnerability]"]

**MCP Tools Integration**: [Specify which MCP tools will be used for automated testing - e.g., "nmap-mcp for network scanning, sqlmap-mcp for injection testing"]

**AI Automation**: [Describe how AI-driven automation will enhance this test - e.g., "AI will analyze results and suggest remediation strategies"]

**Test Scenarios**:

1. **Given** [target state], **When** [attack technique], **Then** [expected vulnerability outcome]
2. **Given** [target state], **When** [attack technique], **Then** [expected vulnerability outcome]

---

### Security Scenario 2 - [Brief Title] (Priority: P2)

[Describe this security scenario in plain language]

**Why this priority**: [Explain the security impact and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Test Scenarios**:

1. **Given** [target state], **When** [attack technique], **Then** [expected vulnerability outcome]

---

### Security Scenario 3 - [Brief Title] (Priority: P3)

[Describe this security scenario in plain language]

**Why this priority**: [Explain the security impact and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Test Scenarios**:

1. **Given** [target state], **When** [attack technique], **Then** [expected vulnerability outcome]

---

[Add more security scenarios as needed, each with an assigned priority]

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

- What happens when [boundary condition]?
- How does system handle [error scenario]?
- What are the implications of [unusual configuration]?

## Security Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right security requirements.
-->

### Technical Security Requirements

- **SR-001**: Assessment MUST [specific capability, e.g., "test for SQL injection vulnerabilities"]
- **SR-002**: Assessment MUST [specific capability, e.g., "validate input sanitization mechanisms"]  
- **SR-003**: Assessment MUST be able to [key security test, e.g., "bypass authentication mechanisms"]
- **SR-004**: Assessment MUST [data requirement, e.g., "identify sensitive data exposure"]
- **SR-005**: Assessment MUST [behavior, e.g., "document all security findings with severity ratings"]

*Example of marking unclear requirements:*

- **SR-006**: Assessment MUST test [NEEDS CLARIFICATION: specific authentication method not specified - OAuth, JWT, Basic Auth?]
- **SR-007**: Assessment MUST evaluate [NEEDS CLARIFICATION: specific technology stack not specified]

### Key Security Targets *(include if assessment involves specific systems)*

- **[Target 1]**: [What it represents, key security attributes without implementation details]
- **[Target 2]**: [What it represents, security relationships to other systems]

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: [Measurable metric, e.g., "Identify all critical vulnerabilities within scope"]
- **SC-002**: [Measurable metric, e.g., "Provide detailed remediation steps for each finding"]
- **SC-003**: [Security coverage metric, e.g., "Achieve 95% coverage of OWASP Top 10 vulnerabilities"]
- **SC-004**: [Business metric, e.g., "Reduce security risk score by [X]% through identified fixes"]
