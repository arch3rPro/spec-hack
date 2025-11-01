---

description: "Security assessment task template"
---

# Security Assessment Tasks: [ASSESSMENT]

**Input**: Assessment plan from `/specs/[###-assessment-name]/`
**Prerequisites**: plan.md (required), scope.md (required for target definition), methodology.md, tools/, authorization/

**Tests**: The examples below include validation tasks. Validation is REQUIRED for all assessment findings.

**Organization**: Tasks are grouped by security assessment phases to enable systematic evaluation and reporting.

## Format: `[ID] [P?] [Phase] Description`

- **[P]**: Can run in parallel (different targets, no dependencies)
- **[Phase]**: Which assessment phase this task belongs to (e.g., REC, VULN, EXP, REPORT)
- Include exact target paths and tool configurations in descriptions

## Assessment Conventions

- **Network assessment**: `targets/`, `reports/` at repository root
- **Web application**: `web/targets/`, `web/reports/`
- **Mobile**: `mobile/targets/`, `mobile/reports/`
- **Infrastructure**: `infra/targets/`, `infra/reports/`
- Paths shown below assume network assessment - adjust based on plan.md structure

<!-- 
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.
  
  The /spechack.tasks command MUST replace these with actual tasks based on:
  - Security scenarios from spec.md (with their priorities P1, P2, P3...)
  - Assessment requirements from plan.md
  - Targets from data-model.md
  - Test cases from contracts/
  
  Tasks MUST be organized by security scenario so each scenario can be:
  - Executed independently
  - Validated independently
  - Reported as an independent finding
  
  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Reconnaissance (Information Gathering)

**Purpose**: Initial information gathering and target identification using AI-driven automation with MCP tools

- [ ] T001 Initialize MCP connection to security tools framework
- [ ] T002 Perform passive reconnaissance on target using Shodan MCP
- [ ] T003 Identify target technologies and services using Nmap MCP
- [ ] T004 [P] Map attack surface and identify entry points using automated analysis
- [ ] T005 [P] Cross-reference findings with threat intelligence MCP servers

---

## Phase 2: Vulnerability Assessment (Scanning)

**Purpose**: Automated vulnerability scanning and analysis using MCP tools and AI-driven analysis

**⚠️ CRITICAL**: No exploitation attempts should begin until this phase is complete

- [ ] T006 Configure and run vulnerability scanner using Nikto MCP
- [ ] T007 [P] Analyze scan results and identify potential vulnerabilities using AI analysis
- [ ] T008 [P] Cross-reference discovered services with CVE MCP database
- [ ] T009 [P] Validate false positives through automated verification and manual review
- [ ] T010 Prioritize findings based on risk, exploitability, and available exploits
- [ ] T011 [P] Generate preliminary attack paths using AI-driven analysis

**Checkpoint**: Vulnerability assessment complete - exploitation planning can now begin

---

## Phase 3: Security Scenario 1 - [Title] (Priority: P1) 🎯 Critical

**Goal**: [Brief description of what this security scenario tests]

**Independent Test**: [How to verify this scenario works on its own]

### Validation for Security Scenario 1

- [ ] T012 [P] [SC1] Verify vulnerability exists through [technique] using MCP tools in evidence/[scenario]/
- [ ] T013 [P] [SC1] Document proof of concept with automated screenshots in evidence/[scenario]/
- [ ] T014 [P] [SC1] Cross-reference vulnerability with CVE MCP database for additional context

### Exploitation for Security Scenario 1

- [ ] T015 [P] [SC1] Develop exploit for [vulnerability] using Metasploit MCP integration in exploits/[scenario]/
- [ ] T016 [SC1] Execute exploit against target using MCP framework in evidence/[scenario]/
- [ ] T017 [SC1] Document impact and risk assessment with AI-generated analysis in reports/[scenario].md
- [ ] T018 [SC1] Recommend remediation steps with automated patch references in reports/[scenario].md

**Checkpoint**: At this point, Security Scenario 1 should be fully documented with evidence

---

## Phase 4: Security Scenario 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this security scenario tests]

**Independent Test**: [How to verify this scenario works on its own]

### Validation for Security Scenario 2

- [ ] T014 [P] [SC2] Verify vulnerability exists through [technique] in evidence/[scenario]/
- [ ] T015 [P] [SC2] Document proof of concept with screenshots in evidence/[scenario]/

### Exploitation for Security Scenario 2

- [ ] T016 [P] [SC2] Develop exploit for [vulnerability] in exploits/[scenario]/
- [ ] T017 [SC2] Execute exploit against target in evidence/[scenario]/
- [ ] T018 [SC2] Document impact and risk assessment in reports/[scenario].md

**Checkpoint**: At this point, Security Scenarios 1 AND 2 should both be fully documented

---

## Phase 5: Security Scenario 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this security scenario tests]

**Independent Test**: [How to verify this scenario works on its own]

### Validation for Security Scenario 3

- [ ] T019 [P] [SC3] Verify vulnerability exists through [technique] in evidence/[scenario]/
- [ ] T020 [P] [SC3] Document proof of concept with screenshots in evidence/[scenario]/

### Exploitation for Security Scenario 3

- [ ] T021 [P] [SC3] Develop exploit for [vulnerability] in exploits/[scenario]/
- [ ] T022 [SC3] Execute exploit against target in evidence/[scenario]/
- [ ] T023 [SC3] Document impact and risk assessment in reports/[scenario].md

**Checkpoint**: All security scenarios should now be fully documented with evidence

---

[Add more security scenario phases as needed, following the same pattern]

---

## Phase N: Reporting & Remediation

**Purpose**: Final reporting and remediation recommendations

- [ ] TXXX [P] Compile executive summary in reports/executive-summary.md
- [ ] TXXX [P] Create technical findings report in reports/technical-findings.md
- [ ] TXXX [P] Develop remediation roadmap in reports/remediation-plan.md
- [ ] TXXX [P] Validate all evidence is properly documented in evidence/
- [ ] TXXX [P] Review and sanitize all sensitive data before delivery

---

## Dependencies & Execution Order

### Phase Dependencies

- **Reconnaissance (Phase 1)**: No dependencies - can start immediately
- **Vulnerability Assessment (Phase 2)**: Depends on Reconnaissance completion - BLOCKS all exploitation
- **Security Scenarios (Phase 3+)**: All depend on Vulnerability Assessment completion
  - Security scenarios can then proceed in parallel (if resources allow)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Reporting (Final Phase)**: Depends on all desired security scenarios being complete

### Security Scenario Dependencies

- **Security Scenario 1 (P1)**: Can start after Vulnerability Assessment (Phase 2) - No dependencies on other scenarios
- **Security Scenario 2 (P2)**: Can start after Vulnerability Assessment (Phase 2) - May share targets with SC1 but should be independently testable
- **Security Scenario 3 (P3)**: Can start after Vulnerability Assessment (Phase 2) - May share targets with SC1/SC2 but should be independently testable

### Within Each Security Scenario

- Validation MUST be completed before exploitation
- Exploitation before documentation
- Documentation before remediation recommendations
- Scenario complete before moving to next priority

### Parallel Opportunities

- All Reconnaissance tasks marked [P] can run in parallel
- All Vulnerability Assessment tasks marked [P] can run in parallel (within Phase 2)
- Once Vulnerability Assessment phase completes, all security scenarios can start in parallel (if team capacity allows)
- All validation tasks for a scenario marked [P] can run in parallel
- Different security scenarios can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together (if tests requested):
Task: "Contract test for [endpoint] in tests/contract/test_[name].py"
Task: "Integration test for [user journey] in tests/integration/test_[name].py"

# Launch all models for User Story 1 together:
Task: "Create [Entity1] model in src/models/[entity1].py"
Task: "Create [Entity2] model in src/models/[entity2].py"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
