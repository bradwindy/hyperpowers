# Shared Reinforcement Patterns

> **Usage:** Reference these patterns when writing discipline-enforcing skills.
> **Version:** 1.0 (2026-01-15)

## Pattern 1: Gate Structure

Use exact format. Deviation reduces recognition.

<example>
**[Gate Name] Gate** (Required):

- [ ] First requirement
- [ ] Second requirement

**STOP CONDITION:** If ANY unchecked, do NOT proceed. [Recovery action].
</example>

**Key elements:**
- "Required" keyword (softer than COMPULSORY, still clear)
- Checkbox format (visual tracking)
- STOP CONDITION with specific recovery

---

## Pattern 2: Red Flags Table

3-column format triggers agent recognition.

<example>
## Red Flags - STOP

| Violation | Why It's Critical | Recovery |
|-----------|-------------------|----------|
| [Observable behavior] | [Consequence] | [Fix action] |
</example>

**Key elements:**
- Header: "Red Flags - STOP" (urgency without caps lock)
- Column 1: Observable behavior (not abstract concepts)
- Column 3: Recovery action (escape path)

---

## Pattern 3: Self-Check Questions

Help agents recognize rationalization.

<example>
| Thought | Reality |
|---------|---------|
| "[Rationalization in first person]" | [Counter statement] |
</example>

---

## Pattern 4: Handoff Consumption

Enforce citation when receiving handoffs.

<example>
**[Source] Consumption Gate** (Required):

- [ ] Source path explicitly stated
- [ ] Key findings quoted
- [ ] Decisions traced to findings

**STOP CONDITION:** If not citing findings, STOP. Quote specific sections.
</example>

---

## Pattern 5: Counter-Rationalization

Pre-written counters for predictable excuses.

<example>
| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
</example>

---

## Pattern 6: Evidence Requirements

For verification-focused skills.

<example>
**Evidence Required:**
- Show [command] output
- Show [specific result]

"[Weak claim]" is NOT evidence. [Strong evidence] required.
</example>

---

## Pattern 7: Beginning-End Anchoring

<example>
## Overview
[Brief description]

<requirements>
1. Requirement 1
2. Requirement 2
</requirements>

[... middle content ...]

<requirements>
## Requirements (reminder)
1. Requirement 1
2. Requirement 2
</requirements>

## Deliverable
</example>

---

## Pattern 8: Output Gate

Enforce file creation with evidence.

<example>
**Output Gate** (Required - NEVER skip):

STOP. Before announcing completion, verify:
- [ ] File EXISTS at `[expected-path]`
- [ ] Quote the first line of the file you just wrote (proof you wrote it)

If file doesn't exist, you have NOT completed [phase]. Write it now.
</example>

**Key elements:**
- Evidence requirement (quote first line)
- Explicit recovery action
- "NEVER skip" adds weight without diluting signal

---

## Pattern 9: Dispatch Gate

Enforce parallel dispatch with count verification.

<example>
**Dispatch Gate** (Required - NEVER skip):

STOP. Before proceeding to [next phase], verify:
- [ ] All [N] [agents/items] dispatched in ONE message
- [ ] Count ≥ [N]

If count < [N], you have NOT completed dispatch. Send remaining NOW.
</example>

**Key elements:**
- Explicit count requirement
- "ONE message" prevents sequential dispatch
- Recovery is immediate action

---

## Pattern 10: Completion Enforcement

Enforce handoff format in final message.

<example>
**Completion Enforcement** (CRITICAL):

Your FINAL message MUST contain the handoff block. This is NOT optional.

STOP. Look at your planned final message. Does it contain:
```
[Type] saved to `[path]`.

To continue:
/compact ready to [next-phase] [path]
/hyperpowers:[next-skill] [path]
```

If NO: Add it. You cannot announce completion without this exact block.
If YES: Proceed with sending.
</example>

**Key elements:**
- Template shows exact format
- Pre-send verification
- No "mention casually" escape hatch

---

## Pattern 11: Compliance Anchoring

Add at START and END of skills invoked via commands.

<example>
<!-- At START of skill -->
<compliance-anchor>
You have invoked this skill. You MUST:
- Follow phases in order (no skipping)
- Complete all gates (no self-exemptions)
- Produce required outputs (no substitutions)

Failure to comply = skill failure. There is no "partial compliance."
</compliance-anchor>

<!-- At END of skill, before final requirements reminder -->
<completion-check>
Before announcing completion, verify you followed the skill:
- [ ] Completed all phases in order
- [ ] Passed all verification gates
- [ ] Produced required outputs to required locations

If ANY unchecked, go back and complete missing steps.
</completion-check>
</example>

**Key elements:**
- Beginning-End Anchoring (Pattern 7) extended to skill compliance
- Explicit "no partial compliance" statement
- Checklist before final message

---

## Anti-Patterns

| Anti-Pattern | Problem | Instead |
|--------------|---------|---------|
| ALL CAPS FOR EMPHASIS | Claude 4.x ignores | Logical consequence statement |
| "MUST/CRITICAL/COMPULSORY" × 12 | Signal dilution | 3-4 per skill max |
| Checklist after action | Too late to catch violations | Checklist BEFORE action |
| "No exceptions" repeated | Loses meaning | One explicit "No exceptions" list |
| Long prohibition lists | Distracts from core task | Focus on what TO do |
