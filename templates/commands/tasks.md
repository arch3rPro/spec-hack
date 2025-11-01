---
description: Generate an actionable, dependency-ordered tasks.md for the security assessment based on available design artifacts.
scripts:
  sh: scripts/bash/check-prerequisites.sh --json
  ps: scripts/powershell/check-prerequisites.ps1 -Json
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `{SCRIPT}` from repo root and parse ASSESSMENT_DIR and AVAILABLE_DOCS list. All paths must be absolute. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load design documents**: Read from ASSESSMENT_DIR:
   - **Required**: plan.md (security tools, frameworks, structure), spec.md (security scenarios with priorities)
   - **Optional**: scope.md (targets), methodology/ (assessment procedures), research.md (decisions), quickstart.md (test scenarios)
   - Note: Not all assessments have all documents. Generate tasks based on what's available.

3. **Execute task generation workflow**:
   - Load plan.md and extract security tools, frameworks, assessment structure
   - Load spec.md and extract security scenarios with their priorities (P1, P2, P3, etc.)
   - If scope.md exists: Extract targets and map to security scenarios
   - If methodology/ exists: Map procedures to security scenarios
   - If research.md exists: Extract decisions for setup tasks
   - Generate tasks organized by security scenario (see Task Generation Rules below)
   - Generate dependency graph showing security scenario completion order
   - Create parallel execution examples per security scenario
   - Validate task completeness (each security scenario has all needed tasks, independently executable)

4. **Generate tasks.md**: Use `templates/tasks-template.md` as structure, fill with:
   - Correct assessment name from plan.md
   - Phase 1: Setup tasks (assessment initialization)
   - Phase 2: Foundational tasks (reconnaissance and information gathering)
   - Phase 3+: One phase per security scenario (in priority order from spec.md)
   - Each phase includes: scenario goal, validation criteria, exploitation tasks
   - Final Phase: Reporting & Remediation
   - All tasks must follow the strict checklist format (see Task Generation Rules below)
   - Clear file paths for each task
   - Dependencies section showing scenario completion order
   - Parallel execution examples per scenario
   - Assessment strategy section (reconnaissance first, systematic testing)

5. **Report**: Output path to generated tasks.md and summary:
   - Total task count
   - Task count per security scenario
   - Parallel opportunities identified
   - Validation criteria for each scenario
   - Suggested initial scope (typically just Security Scenario 1)
   - Format validation: Confirm ALL tasks follow the checklist format (checkbox, ID, labels, file paths)

Context for task generation: {ARGS}

The tasks.md should be immediately executable - each task must be specific enough that an LLM can complete it without additional context.

## Task Generation Rules

**CRITICAL**: Tasks MUST be organized by security scenario to enable independent execution and validation.

### Checklist Format (REQUIRED)

Every task MUST strictly follow this format:

```text
- [ ] [TaskID] [P?] [SC?] Description with file path
```

**Format Components**:

1. **Checkbox**: ALWAYS start with `- [ ]` (markdown checkbox)
2. **Task ID**: Sequential number (T001, T002, T003...) in execution order
3. **[P] marker**: Include ONLY if task is parallelizable (different targets, no dependencies on incomplete tasks)
4. **[SC] label**: REQUIRED for security scenario phase tasks only
   - Format: [SC1], [SC2], [SC3], etc. (maps to security scenarios from spec.md)
   - Setup phase: NO scenario label
   - Foundational phase: NO scenario label  
   - Security Scenario phases: MUST have scenario label
   - Reporting phase: NO scenario label
5. **Description**: Clear action with exact file path

**Examples**:

- ✅ CORRECT: `- [ ] T001 Create assessment structure per assessment plan`
- ✅ CORRECT: `- [ ] T005 [P] Perform network reconnaissance in results/network-scan.md`
- ✅ CORRECT: `- [ ] T012 [P] [SC1] Test for SQL injection in results/web-vuln-scan.md`
- ✅ CORRECT: `- [ ] T014 [SC1] Exploit identified XSS vulnerability in evidence/xss-poc.md`
- ❌ WRONG: `- [ ] Test for SQL injection` (missing ID and Scenario label)
- ❌ WRONG: `T001 [SC1] Test vulnerability` (missing checkbox)
- ❌ WRONG: `- [ ] [SC1] Test vulnerability` (missing Task ID)
- ❌ WRONG: `- [ ] T001 [SC1] Test vulnerability` (missing file path)

### Task Organization

1. **From Security Scenarios (spec.md)** - PRIMARY ORGANIZATION:
   - Each security scenario (P1, P2, P3...) gets its own phase
   - Map all related components to their scenario:
     - Targets needed for that scenario
     - Procedures needed for that scenario
     - Evidence collection needed for that scenario
   - Mark scenario dependencies (most scenarios should be independent)

2. **From Methodology**:
   - Map each procedure → to the security scenario it serves
   - Each procedure → validation task [P] before exploitation in that scenario's phase

3. **From Scope**:
   - Map each target to the security scenario(ies) that need it
   - If target serves multiple scenarios: Put in earliest scenario or Setup phase
   - Target relationships → reconnaissance tasks in appropriate scenario phase

4. **From Setup/Infrastructure**:
   - Shared infrastructure → Setup phase (Phase 1)
   - Foundational/blocking tasks → Foundational phase (Phase 2)
   - Scenario-specific setup → within that scenario's phase

### Phase Structure

- **Phase 1**: Setup (assessment initialization)
- **Phase 2**: Foundational (reconnaissance and information gathering - MUST complete before security scenarios)
- **Phase 3+**: Security Scenarios in priority order (P1, P2, P3...)
  - Within each scenario: Validation → Exploitation → Documentation
  - Each phase should be a complete, independently executable increment
- **Final Phase**: Reporting & Remediation

## Quality Checklist

- [ ] Tasks follow strict checklist format (checkbox, ID, labels, file paths)
- [ ] All tasks have clear, specific file paths
- [ ] Parallel tasks correctly marked with [P]
- [ ] Security scenario tasks correctly marked with [SC#]
- [ ] Dependencies section shows scenario completion order
- [ ] Each security scenario has validation criteria
- [ ] No blocking dependencies between scenarios
- [ ] Assessment strategy emphasizes reconnaissance first
- [ ] Setup phase includes all assessment initialization tasks
- [ ] Foundational phase includes all reconnaissance tasks
- [ ] Each security scenario is independently executable
- [ ] Final phase includes reporting and remediation tasks

## Key Rules

1. **Security Scenario Independence**: Each security scenario phase must be independently executable and verifiable
2. **Sequential Scenario Execution**: Security scenarios should be executed in priority order (P1, P2, P3...)
3. **Reconnaissance First**: Foundational phase (reconnaissance) must complete before any security scenarios
4. **Clear Evidence Paths**: All tasks must specify exact file paths for evidence collection
5. **Parallel Validation**: Multiple security scenarios can be validated in parallel once reconnaissance is complete
6. **Scenario Completion**: Each scenario must be complete with validation, exploitation, and documentation
7. **Final Reporting**: All findings must be consolidated in the final reporting phase
