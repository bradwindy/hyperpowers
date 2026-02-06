---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
allowed-tools: Task, Bash, Read
---

# Requesting Code Review

## Overview

Dispatch 4 specialized review agents in parallel to catch issues before they cascade.

**Core principle:** Review early, review often.

<requirements>
## Requirements

1. Include context for reviewers. Code without context produces unclear feedback.
2. Specify what feedback you need. Vague requests get vague responses.
3. Provide test evidence. Claims without proof are unverifiable.
</requirements>

## When to Request Review

**Mandatory:**
- After each task in subagent-driven development
- After completing major feature
- Before merge to main

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing complex bug

## Specialized Review Pattern

Code review dispatches 4 parallel specialized agents:

| Agent | Focus | Key Checks |
|-------|-------|-----------|
| **Security Reviewer** | Vulnerabilities | Injection, auth, secrets, input validation |
| **Performance Reviewer** | Efficiency | N+1, memory leaks, scaling, caching |
| **Style Reviewer** | Conventions | Naming, organization, patterns, formatting |
| **Test Reviewer** | Coverage | Gaps, edge cases, test quality |

Each agent reviews the same changes independently, then findings are synthesized by severity.

### Model Selection

All 4 specialized agents use `haiku` for fast, focused analysis.
Orchestrator (you) handles synthesis with full reasoning capability.

## Quick Reference

| Step | Action |
|------|--------|
| 1 | Gather git context (BASE_SHA, HEAD_SHA) |
| 2 | Summarize what was implemented |
| 3 | Spawn review team |
| 3.5 | Team cleanup | Clean up review team |
| 4 | Synthesize findings by severity |
| 5 | Check docs/hyperpowers/solutions/ for known fixes |
| 6 | Present unified checklist |

## How to Request Code Review

### Step 1: Gather Git Context

```bash
BASE_SHA=$(git merge-base HEAD origin/main)  # or appropriate base
HEAD_SHA=$(git rev-parse HEAD)
git diff $BASE_SHA..$HEAD_SHA --stat
```

### Step 2: Identify What Was Implemented

Summarize the changes:
- What feature/fix was implemented
- Which files were changed
- What requirements it should meet

### Step 3: Spawn Review Team

**Create an agent team** named "Code Review: [summary of changes]" with the following teammates:

For each reviewer, use the agent definition content from the corresponding file in `agents/review/` as their spawn prompt. Include:
- The git diff or changed file contents
- Summary of what was implemented
- The instruction: "You are operating as a teammate. Follow the Teammate Instructions section in your agent definition. Share cross-domain findings with relevant teammates."

**Teammate spawn list:**

1. **Security Reviewer** — spawn with content from `agents/review/security-reviewer.md` plus diff context
2. **Performance Reviewer** — spawn with content from `agents/review/performance-reviewer.md` plus diff context
3. **Style Reviewer** — spawn with content from `agents/review/style-reviewer.md` plus diff context
4. **Test Reviewer** — spawn with content from `agents/review/test-reviewer.md` plus diff context

Reviewers should:
1. Conduct their specialized review
2. When they find an issue that touches another reviewer's domain, message that reviewer directly via `write`
3. After completing their own review, read other reviewers' findings and add any cross-domain observations
4. Use `broadcast` only for critical findings that all reviewers need to know

**After spawning:** Wait for all reviewers to complete their reviews and cross-domain discussion.

### Step 3.5: Review Team Cleanup

After all reviewers complete:
1. Request shutdown for all reviewer teammates
2. Wait for all teammates to approve shutdown
3. Call cleanup to remove team resources
4. Retry cleanup up to 3 times if it fails
5. If cleanup fails after 3 retries, escalate to user via AskUserQuestion

### Step 4: Synthesize Findings

After review team is cleaned up, combine findings by severity. Findings are now enriched with cross-domain observations from reviewer collaboration.

```markdown
## Code Review Results

### Critical Issues
[Must fix before merge]
- [ ] **[CATEGORY]** [Issue] at `file:line`
  - [Details and fix recommendation]
  - Cross-domain note: [if multiple reviewers flagged this]

### Warnings
[Should fix, may proceed with justification]
- [ ] **[CATEGORY]** [Issue] at `file:line`
  - [Details and fix recommendation]
  - Cross-domain note: [if applicable]

### Suggestions
[Optional improvements]
- [ ] **[CATEGORY]** [Issue] at `file:line`
  - [Details]

### Cross-Domain Insights
[Findings that span multiple review domains]
- **[Domain A + Domain B]**: [Cross-cutting finding] at `file:line`
  - [How the domains interact and why this matters]
```

### Step 5: Check for Known Solutions

For Critical/Warning findings, check `docs/hyperpowers/solutions/` for prior solutions:
- If match found: Include link in recommendation
- Example: "See `docs/hyperpowers/solutions/performance-issues/n-plus-one-2026-01-08.md`"

### Step 6: Present to User

Present the synthesized checklist. User should:
- Fix all Critical issues
- Address Warnings before merge (or justify skipping)
- Consider Suggestions for future improvement

## Example

```
[Just completed Task 2: Add verification function]

You: Let me request code review before proceeding.

BASE_SHA=$(git merge-base HEAD origin/main)
HEAD_SHA=$(git rev-parse HEAD)

[Dispatch 4 parallel review agents with diff context]

[All agents return, orchestrator synthesizes]:

## Code Review Results

### Critical Issues
(none)

### Warnings
- [ ] **[PERFORMANCE]** verifyIndex() loads entire file into memory at `src/verify.ts:45`
  - Consider streaming for large files

### Suggestions
- [ ] **[STYLE]** Magic number (100) for reporting interval at `src/verify.ts:78`
  - Extract to named constant
- [ ] **[TEST]** Missing edge case test for empty index at `tests/verify.test.ts`
  - Add test for empty index scenario

You: [Fix memory issue, note suggestions for later]
[Continue to Task 3]
```

## Integration with Workflows

**Subagent-Driven Development:**
- Review after EACH task
- Catch issues before they compound
- Fix before moving to next task

**Executing Plans:**
- Review after each batch (3 tasks)
- Get feedback, apply, continue

**Ad-Hoc Development:**
- Review before merge
- Review when stuck

## Red Flags

**Avoid:**
- Skipping review because "it's simple"
- Ignoring high-severity issues
- Proceeding with unfixed issues
- Arguing with valid technical feedback

**If reviewer wrong:**
- Push back with technical reasoning
- Show code/tests that prove it works
- Request clarification

<verification>
## Pre-Dispatch Verification

Before dispatching review agents, verify context is complete:

**Context Gate:**

- [ ] BASE_SHA and HEAD_SHA captured
- [ ] Git diff generated
- [ ] Summary of changes prepared

**STOP CONDITION:** If context incomplete, gather it before dispatching agents.

**Spawn Gate:**

- [ ] Security Reviewer spawned as teammate
- [ ] Performance Reviewer spawned as teammate
- [ ] Style Reviewer spawned as teammate
- [ ] Test Reviewer spawned as teammate
- [ ] Team cleanup completed before synthesis

**STOP CONDITION:** If fewer than 4 reviewers spawned, spawn missing reviewers.
</verification>

<verification>
## Post-Completion Verification

After agents return, verify synthesis is complete:

**Synthesis Gate:**

- [ ] All 4 agents completed
- [ ] Findings grouped by severity (Critical/Warning/Suggestion)
- [ ] Checked docs/hyperpowers/solutions/ for known fixes
- [ ] Unified checklist presented

**STOP CONDITION:** If any agent missing from synthesis, wait or re-dispatch.

**Consumption Gate (for each reviewer's findings):**

- [ ] Each reviewer's output file path stated
- [ ] Key findings from EACH reviewer quoted/referenced
- [ ] Severity classifications traced back to specific reviewer

**STOP CONDITION:** If synthesizing without citing specific reviewer outputs, quote each reviewer's findings.
</verification>

<requirements>
## Requirements Reminder

1. Include context for reviewers. Code without context produces unclear feedback.
2. Specify what feedback you need. Vague requests get vague responses.
3. Provide test evidence. Claims without proof are unverifiable.
</requirements>
