# Security Assessment-Driven Development (SADD)

A methodology for using AI to transform security specifications into comprehensive, systematic security assessments through a structured process of iterative refinement and vulnerability discovery.

## The Power Inversion

Traditional security assessment: scoping → manual testing → report generation

SADD: security specification → automated assessment → validation & exploitation

## The SADD Workflow in Practice

The workflow begins with a security specification—often high-level security objectives and compliance requirements. Through iterative dialogue with AI, this specification becomes a comprehensive security assessment plan. The AI asks clarifying questions about threat models, attack surfaces, and security controls. What might take weeks of manual security analysis happens in hours of focused security specification work. This transforms the traditional security assessment—scope definition and methodology become continuous activities rather than discrete phases. This is supportive of a **security team process**, where peer-reviewed security specifications are expressed and versioned, created in branches, and merged.

When a security analyst updates threat models, assessment plans automatically flag affected testing procedures. When a security architect discovers new attack vectors, the specification updates to reflect new testing scenarios.

Throughout this security specification process, research agents gather critical security context. They investigate vulnerability databases, attack patterns, and security tool capabilities. Organizational security policies are discovered and applied automatically—your company's security standards, compliance requirements, and risk tolerance seamlessly integrate into every security specification.

From the security specification, AI generates assessment plans that map security objectives to technical testing procedures. Every tool choice has documented security rationale. Every testing decision traces back to specific security requirements. Throughout this process, security validation continuously improves assessment quality. AI analyzes security specifications for gaps, contradictions, and insufficient coverage—not as a one-time gate, but as an ongoing refinement.

Automated assessment begins as soon as security specifications and their assessment plans are stable enough, but they do not have to be "complete." Early assessments might be exploratory—testing whether the security specification makes sense in practice. Security concepts become test scenarios. Threat models become attack simulations. Compliance requirements become validation checks. This merges security analysis and testing through specification—test scenarios aren't written after assessment planning, they're part of the specification that generates both assessment procedures and validation checks.

The feedback loop extends beyond initial assessment. Security incidents and breach data don't just trigger new assessments—they update security specifications for the next assessment cycle. New attack techniques become additional testing scenarios. Discovered vulnerabilities become constraints that affect all future assessments. This iterative dance between security specification, automated assessment, and threat intelligence is where true security understanding emerges and where traditional security assessments transform into continuous security validation.

## Why SADD Matters Now

Three trends make SADD not just possible but necessary:

First, AI security capabilities have reached a threshold where natural language security specifications can reliably generate comprehensive security assessments. This isn't about replacing security analysts—it's about amplifying their effectiveness by automating the mechanical translation from security requirements to testing procedures. It can amplify vulnerability discovery, support continuous security validation, and enhance threat modeling capabilities.

Second, system complexity continues to grow exponentially. Modern applications integrate dozens of services, frameworks, and dependencies, creating expanding attack surfaces. Manual security testing cannot keep pace with this complexity. SADD provides systematic security alignment through security assessment-driven development. Security frameworks may evolve to provide AI-first vulnerability discovery, not human-first testing, or architect around reusable security assessment components.

Third, the pace of deployment accelerates. Applications change far more rapidly today than ever before. Continuous deployment is no longer exceptional—it's expected. Modern security demands rapid assessment based on new features, emerging threats, and discovered vulnerabilities. Traditional security assessment treats these changes as disruptions. Each update requires manually updating threat models, test cases, and security controls. The result is either slow, careful assessments that limit velocity, or fast, incomplete testing that accumulates security debt.

SADD can support what-if/simulation experiments: "If we need to re-implement or change the application to promote a business need to sell more T-shirts, how would this impact our security posture and what new vulnerabilities might emerge?"

SADD transforms security requirement changes from obstacles into normal workflow. When security specifications drive assessment, pivots become systematic security re-evaluations rather than manual rewrites. Change a core security requirement, and affected assessment plans update automatically. Modify a threat model, and corresponding test scenarios regenerate. This isn't just about initial security assessment—it's about maintaining security velocity through inevitable changes.

## Core Principles

**Security Specifications as the Lingua Franca**: The security specification becomes the primary artifact. Security assessments become its expression in particular testing procedures and tools. Maintaining security means evolving specifications.

**Executable Security Specifications**: Security specifications must be precise, complete, and unambiguous enough to generate working security assessments. This eliminates the gap between security requirements and testing procedures.

**Continuous Security Refinement**: Security validation happens continuously, not as a one-time gate. AI analyzes security specifications for gaps, contradictions, and insufficient coverage as an ongoing process.

**Research-Driven Security Context**: Research agents gather critical security context throughout the specification process, investigating vulnerability databases, attack patterns, and security tool capabilities.

**Bidirectional Security Feedback**: Security incidents and breach data inform specification evolution. Discovered vulnerabilities and new attack techniques become inputs for security specification refinement.

**Branching for Security Exploration**: Generate multiple security assessment approaches from the same specification to explore different security targets—coverage, depth, compliance, risk mitigation.

## Implementation Approaches

SADD can be implemented in several ways, depending on the organization's security needs and capabilities:

1. **Template-Based**: Using predefined security assessment templates for specifications and assessment plans
2. **AI-Assisted**: Using AI tools to help create and refine security specifications and testing procedures
3. **Fully Automated**: Using AI to generate both security specifications and assessment procedures from high-level security objectives
4. **Hybrid**: Combining human security expertise with AI capabilities for optimal security coverage

Each approach offers different trade-offs between security coverage, speed, and depth of assessment.

## Streamlining SADD with Commands

The SADD methodology is significantly enhanced through three powerful commands that automate the security specification → assessment planning → security testing workflow:

### The `/spechack.spec` Command

This command transforms a simple security requirement description into a complete, structured security specification with automatic repository management:

1. **Automatic Assessment Numbering**: Scans existing security specs to determine the next assessment number (e.g., 001, 002, 003)
2. **Branch Creation**: Generates a semantic branch name from your security description and creates it automatically
3. **Template-Based Generation**: Copies and customizes the security specification template with your requirements
4. **Directory Structure**: Creates the proper `security-specs/[branch-name]/` structure for all related documents

### The `/spechack.plan` Command

Once a security specification exists, this command creates a comprehensive security assessment plan:

1. **Security Specification Analysis**: Reads and understands the security requirements, threat models, and compliance criteria
2. **Security Framework Compliance**: Ensures alignment with organizational security policies and standards
3. **Technical Security Translation**: Converts security requirements into technical testing procedures and vulnerability assessments
4. **Detailed Security Documentation**: Generates supporting documents for attack scenarios, vulnerability matrices, and security test cases
5. **Security Validation**: Produces a security validation guide capturing key assessment scenarios

### The `/spechack.tasks` Command

After a security assessment plan is created, this command analyzes the plan and related security documents to generate an executable security testing task list:

1. **Inputs**: Reads `plan.md` (required) and, if present, `threat-model.md`, `vulnerability-matrix.md`, and `security-research.md`
2. **Security Task Derivation**: Converts security requirements, attack scenarios, and vulnerability assessments into specific testing tasks
3. **Parallelization**: Marks independent security testing tasks `[P]` and outlines safe parallel testing groups
4. **Output**: Writes `security-tasks.md` in the assessment directory, ready for execution by security testing agents

### Example: Conducting a Web Application Security Assessment

Here's how these commands transform the traditional security assessment workflow:

**Traditional Approach:**

```text
1. Define security scope manually (2-3 hours)
2. Create threat models (2-3 hours)
3. Set up testing tools manually (30 minutes)
4. Write security test cases (3-4 hours)
5. Generate assessment reports (2 hours)
Total: ~12 hours of security assessment work
```

**SADD with Commands Approach:**

```bash
# Step 1: Create the security specification (5 minutes)
/spechack.spec Comprehensive security assessment of web application with OWASP Top 10 focus

# This automatically:
# - Creates branch "003-web-security-assessment"
# - Generates security-specs/003-web-security-assessment/spec.md
# - Populates it with structured security requirements

# Step 2: Generate security assessment plan (5 minutes)
/spechack.plan OWASP Top 10 vulnerabilities, authentication testing, authorization testing

# Step 3: Generate executable security tasks (5 minutes)
/spechack.tasks

# This automatically creates:
# - security-specs/003-web-security-assessment/plan.md
# - security-specs/003-web-security-assessment/threat-model.md (Attack surface analysis)
# - security-specs/003-web-security-assessment/vulnerability-matrix.md (Risk assessment)
# - security-specs/003-web-security-assessment/security-validation.md (Validation scenarios)
# - security-specs/003-web-security-assessment/security-research.md (Vulnerability research)
# - security-specs/003-web-security-assessment/security-tasks.md (Task list derived from the plan)
```

In 15 minutes, you have:

- A complete security specification with threat models and compliance requirements
- A detailed security assessment plan with testing methodologies and tools
- Vulnerability matrices and threat models ready for assessment execution
- Comprehensive security validation scenarios for both automated and manual testing
- All documents properly versioned in a security assessment branch

### The Power of Structured Automation

These commands don't just save time—they enforce consistency and completeness:

1. **No Forgotten Details**: Templates ensure every security aspect is considered, from threat models to compliance requirements
2. **Traceable Decisions**: Every security testing choice links back to specific security requirements
3. **Living Documentation**: Security specifications stay in sync with assessments because they generate them
4. **Rapid Iteration**: Change security requirements and regenerate assessment plans in minutes, not days

The commands embody SADD principles by treating security specifications as executable artifacts rather than static documents. They transform the security specification process from a necessary evil into the driving force of security assessment.

### Template-Driven Quality: How Structure Constrains LLMs for Better Outcomes

The magic of SADD lies in how templates constrain LLM behavior to produce consistently high-quality security specifications. Rather than giving AI complete freedom, we provide structured frameworks that guide its output toward comprehensive security assessments.

#### 1. **Preventing Premature Testing Tool Details**

The security specification template explicitly forbids detailed testing tool configurations:

```text
**IMPORTANT**: This security specification should remain high-level and readable.
Any detailed tool configurations, specific exploit techniques, or extensive technical security specifications
must be placed in the appropriate `security-testing-details/` file
```

This constraint prevents the LLM from jumping to specific security testing tools before fully understanding the threat landscape. It forces a separation of concerns that mirrors good security assessment methodology.

#### 2. **Forcing Explicit Security Uncertainty Markers**

Both templates mandate the use of `[NEEDS CLARIFICATION]` markers:

```text
When creating this security spec from a user prompt:
1. **Mark all security ambiguities**: Use [NEEDS CLARIFICATION: specific security question]
2. **Don't guess security controls**: If the prompt doesn't specify security aspects, mark them with [NEEDS CLARIFICATION] markers
```

This prevents the common LLM behavior of making plausible but potentially incorrect security assumptions. Instead of guessing that a "login system" uses secure authentication, the LLM must mark it as `[NEEDS CLARIFICATION: security auth method not specified - MFA, SSO, OAuth?]`.

#### 3. **Structured Security Thinking Through Checklists**

The templates include comprehensive security checklists that act as "unit tests" for the security specification:

```markdown
### Security Requirement Completeness
- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Security requirements are testable and unambiguous
- [ ] Security success criteria are measurable
```

These checklists force the LLM to self-review its security output systematically, catching security gaps that might otherwise slip through. It's like giving the LLM a security assessment quality assurance framework.

#### 4. **Security Framework Compliance Through Gates**

The security assessment plan template enforces security principles through phase gates:

```markdown
### Phase -1: Pre-Assessment Gates
#### Security Scope Gate (OWASP Compliance)
- [ ] Using ≤3 assessment categories?
- [ ] No scope creep beyond defined boundaries?
#### Tool Selection Gate (Security Standards)
- [ ] Using industry-standard security tools?
- [ ] Single assessment methodology?
```

These gates prevent over-scoping by making the LLM explicitly justify any additional security testing. If a gate fails, the LLM must document why in the "Security Complexity Tracking" section, creating accountability for security assessment decisions.

#### 5. **Hierarchical Security Detail Management**

The templates enforce proper security information architecture:

```text
**IMPORTANT**: This security assessment plan should remain high-level and readable.
Any detailed exploit techniques, specific tool configurations, or extensive technical security specifications
must be placed in the appropriate `security-testing-details/` file
```

This prevents the common problem of security specifications becoming unreadable technical dumps. The LLM learns to maintain appropriate security detail levels, extracting technical complexity to separate files while keeping the main document navigable.

#### 6. **Security Validation-First Thinking**

The security assessment template enforces security validation-first assessment:

```text
### Security Testing Order
1. Create `threat-models/` with attack surface specifications
2. Create security validation files in order: reconnaissance → vulnerability analysis → exploitation → post-exploitation
3. Create security reports to document findings
```

This ordering constraint ensures the LLM thinks about security validation and attack scenarios before testing procedures, leading to more comprehensive and systematic security assessments.

#### 7. **Preventing Speculative Security Testing**

Templates explicitly discourage security testing speculation:

```text
- [ ] No speculative or "might be useful" security tests
- [ ] All security assessment phases have clear prerequisites and deliverables
```

This stops the LLM from adding "nice to have" security tests that complicate the assessment. Every security test must trace back to a concrete threat scenario with clear validation criteria.

### The Compound Effect

These constraints work together to produce security specifications that are:

- **Complete**: Security checklists ensure no security aspect is forgotten
- **Unambiguous**: Forced security clarification markers highlight uncertainties
- **Testable**: Security validation-first thinking baked into the process
- **Maintainable**: Proper security abstraction levels and information hierarchy
- **Assessable**: Clear security assessment phases with concrete deliverables

The templates transform the LLM from a creative writer into a disciplined security assessment engineer, channeling its capabilities toward producing consistently high-quality, executable security specifications that truly drive security assessments.

## The Security Framework Foundation: Enforcing Security Assessment Discipline

At the heart of SADD lies a security framework—a set of immutable principles that govern how security specifications become assessments. The security framework (`memory/security-framework.md`) acts as the security DNA of the system, ensuring that every generated assessment maintains consistency, thoroughness, and quality.

### The Nine Principles of Security Assessment

The security framework defines nine principles that shape every aspect of the security assessment process:

#### Principle I: Threat Model-First Assessment

Every security assessment must begin with a comprehensive threat model—no exceptions. This forces systematic security analysis from the start:

```text
Every security assessment in Spec Hack MUST begin with a comprehensive threat model.
No security assessment shall be conducted without first analyzing
the attack surface and identifying potential threat vectors.
```

This principle ensures that security specifications generate thorough, systematic assessments rather than ad-hoc testing. When the LLM generates a security assessment plan, it must structure assessments based on identified threats with clear attack scenarios and mitigation strategies.

#### Principle II: Standardized Security Tool Interface

Every security assessment must use standardized security tool interfaces:

```text
All security tool interfaces MUST:
- Accept security targets as input (via configuration files, arguments)
- Produce structured security findings as output (in standard formats like JSON, XML)
- Support common security data exchange protocols (STIX, TAXII)
```

This enforces security observability and interoperability. The LLM cannot hide security findings inside proprietary formats—everything must be accessible and verifiable through standardized security interfaces.

#### Principle III: Security Validation-First Imperative

The most transformative principle—no security assessment without validation:

```text
This is NON-NEGOTIABLE: All security assessments MUST follow strict Security Validation-First methodology.
No security assessment shall be conducted before:
1. Security validation criteria are defined
2. Validation scenarios are approved by security stakeholders
3. Validation scenarios are confirmed to test the intended security controls
```

This completely inverts traditional security testing. Instead of running security tools and hoping they find vulnerabilities, the LLM must first generate comprehensive security validation scenarios that define what security means for the target, get them approved, and only then conduct the assessment.

#### Principles VII & VIII: Focused Assessment and Anti-Tool-Sprawl

Two principles that prevent over-assessment:

```text
Principle VII: Focused Assessment Mandate
- Focus security assessment on identified threats
- Choose targeted security tests over broad tool sweeps
- Value actionable findings over comprehensive coverage

Principle VIII: Anti-Tool-Sprawl Principle
- Don't use security tools unless directly relevant to threats
- Don't test for vulnerabilities that don't apply to the target
- Don't generate security noise without clear remediation value
```

These principles prevent the LLM from generating overly broad security assessments with unnecessary tool sprawl—common pitfalls in automated security testing. The security assessment plan template's "Phase -1 Gates" directly enforce these principles.

#### Principle IX: Attack Chain-First Testing

The final principle ensures comprehensive security testing:

```text
All attack chain tests MUST be written before individual vulnerability tests.
Attack chain tests verify that security controls work together to prevent real-world attacks.
Individual vulnerability tests verify specific security weaknesses.
```

This prevents the common pitfall of finding isolated vulnerabilities that don't represent real attack scenarios. The LLM must design the attack scenarios first, then ensure security controls work together to prevent complete attack chains, and only then test for individual weaknesses.

### Security Framework Enforcement Through Templates

The security assessment plan template operationalizes these principles through concrete checkpoints:

```markdown
### Phase -1: Pre-Assessment Gates
#### Focused Assessment Gate (Principle VII)
- [ ] Focused on identified threats?
- [ ] No unnecessary security tool sprawl?

#### Anti-Tool-Sprawl Gate (Principle VIII)
- [ ] Using tools relevant to threats?
- [ ] Single assessment methodology?

#### Attack Chain-First Gate (Principle IX)
- [ ] Attack scenarios defined?
- [ ] Attack chain tests written?
```

These gates act as validation checks for security assessment principles. The LLM cannot proceed without either passing the gates or documenting justified exceptions in the "Security Complexity Tracking" section.

### The Power of Immutable Security Principles

The security framework's power lies in its immutability. While security assessment techniques can evolve, the core principles remain constant. This provides:

1. **Consistency Across Time**: Security assessments conducted today follow the same principles as assessments conducted next year
2. **Consistency Across LLMs**: Different AI models produce methodologically compatible security assessments
3. **Security Integrity**: Every assessment reinforces rather than undermines the security methodology
4. **Quality Guarantees**: Threat model-first, validation-first, and focused assessment principles ensure thorough security evaluations

### Security Framework Evolution

While principles are immutable, their application can evolve:

```text
Section 4.2: Amendment Process
Modifications to this security framework require:
- Explicit documentation of the rationale for change
- Review and approval by security assessment team
- Backwards compatibility assessment with existing security assessments
```

This allows the methodology to learn and improve while maintaining stability. The security framework shows its own evolution with dated amendments, demonstrating how principles can be refined based on real-world security assessment experience.

### Beyond Rules: A Security Assessment Philosophy

The security framework isn't just a rulebook—it's a philosophy that shapes how LLMs think about security assessment:

- **Standardization Over Proprietary**: Everything must be accessible through standardized security interfaces
- **Focus Over Sprawl**: Start focused on threats, add security tools only when proven necessary
- **Attack Chains Over Isolated Vulnerabilities**: Test in realistic attack scenarios, not artificial ones
- **Threat Model Over Ad-Hoc**: Every assessment is based on a comprehensive threat model with clear boundaries

By embedding these principles into the security specification and planning process, SADD ensures that generated security assessments aren't just technical—they're methodologically sound, threat-focused, and aligned with industry best practices. The security framework transforms AI from a security tool runner into a security assessment partner that respects and reinforces systematic security evaluation principles.

## The Transformation

This isn't about replacing security professionals or automating security expertise. It's about amplifying human security capability by automating mechanical security assessment processes. It's about creating a tight feedback loop where security specifications, threat models, and security assessments evolve together, each iteration bringing deeper understanding and better alignment between security requirements and security validation.

Security assessment needs better tools for maintaining alignment between security requirements and security validation. SADD provides the methodology for achieving this alignment through executable security specifications that generate security assessments rather than merely guiding them.
