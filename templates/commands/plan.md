---
description: Execute the security assessment planning workflow using the plan template to generate assessment artifacts.
scripts:
  sh: scripts/bash/setup-plan.sh --json
  ps: scripts/powershell/setup-plan.ps1 -Json
agent_scripts:
  sh: scripts/bash/update-agent-context.sh __AGENT__
  ps: scripts/powershell/update-agent-context.ps1 -AgentType __AGENT__
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `{SCRIPT}` from repo root and parse JSON for ASSESSMENT_SPEC, ASSESSMENT_PLAN, SPECS_DIR, BRANCH. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load context**: Read ASSESSMENT_SPEC and `/memory/constitution.md`. Load ASSESSMENT_PLAN template (already copied).

3. **Execute assessment planning workflow**: Follow the structure in ASSESSMENT_PLAN template to:
   - Fill Assessment Context (mark unknowns as "NEEDS CLARIFICATION")
   - Fill Constitution Check section from constitution
   - Evaluate gates (ERROR if violations unjustified)
   - Phase 0: Generate research.md (resolve all NEEDS CLARIFICATION)
   - Phase 1: Generate scope.md, methodology/, quickstart.md
   - Phase 1: Update agent context by running the agent script
   - Re-evaluate Constitution Check post-design

4. **Stop and report**: Command ends after Phase 2 planning. Report branch, ASSESSMENT_PLAN path, and generated artifacts.

## Phases

### Phase 0: Outline & Research

1. **Extract unknowns from Assessment Context** above:
   - For each NEEDS CLARIFICATION → research task
   - For each security tool → best practices task
   - For each target system → reconnaissance task

2. **Generate and dispatch research agents**:

   ```text
   For each unknown in Assessment Context:
     Task: "Research {unknown} for {assessment context}"
   For each security tool choice:
     Task: "Find best practices for {tool} in {domain}"
   ```

3. **Consolidate findings** in `research.md` using format:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: research.md with all NEEDS CLARIFICATION resolved

### Phase 1: Assessment Scope & Methodology

**Prerequisites:** `research.md` complete

1. **Extract assessment scope from assessment spec** → `scope.md`:
   - Target systems, applications, networks
   - Assessment boundaries and exclusions
   - Security requirements and compliance frameworks

2. **Generate assessment methodology** from security requirements:
   - For each security control → testing procedure
   - Use standard security frameworks (OWASP, NIST, etc.)
   - Output methodology documents to `/methodology/`

3. **Agent context update**:
   - Run `{AGENT_SCRIPT}`
   - These scripts detect which AI agent is in use
   - Update the appropriate agent-specific context file
   - Add only new security tools from current assessment plan
   - Preserve manual additions between markers

**Output**: scope.md, /methodology/*, quickstart.md, agent-specific file

## Key rules

- Use absolute paths
- ERROR on gate failures or unresolved clarifications
