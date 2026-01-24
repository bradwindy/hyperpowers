---
name: validated-batch-development
description: Use when executing implementation plans with intelligent batching based on buildability and parallel validation checkpoints
allowed-tools: Bash, Read, Grep, Glob, Task, TodoWrite, AskUserQuestion, Write, Edit
---

# Validated Batch Development

Execute plans by grouping tasks into buildable batches, then validating each batch in parallel before proceeding.

**Core principle:** Intelligent batching based on buildability + parallel 3-validator dispatch after each batch.

<requirements>
## Requirements

1. Dispatch batch analyzer before execution. Fixed-size batches ignore buildability.
2. Three validators in parallel after each batch. Sequential validation wastes time.
3. Max 3 fix cycles per batch before escalating. Infinite loops degrade quality.
4. Human checkpoint after each batch. EU AI Act requires human oversight.
</requirements>

## When to Use

- Executing implementation plans where buildability matters
- Want parallel validation (build + spec + code review) after each batch
- Prefer speed of parallel validation over sequential human review per task
- Have plans with interdependent tasks that need buildability boundaries

## Arguments

- Plan path: First argument (e.g., `docs/hyperpowers/plans/feature.md`)

## The Process

```dot
digraph process {
    rankdir=TB;

    "Load Plan" [shape=box];
    "Phase 1: Batch Analysis" [shape=box style=filled fillcolor=lightblue];
    "User approves batches" [shape=diamond];
    "Phase 2: Execute Batch" [shape=box];
    "Phase 3: Parallel Validation" [shape=box style=filled fillcolor=lightyellow];
    "All 3 pass?" [shape=diamond];
    "Fix issues" [shape=box];
    "Fix cycles < 3?" [shape=diamond];
    "Escalate to user" [shape=box style=filled fillcolor=lightcoral];
    "Phase 4: Human Checkpoint" [shape=box style=filled fillcolor=lightgreen];
    "More batches?" [shape=diamond];
    "Completion" [shape=box];

    "Load Plan" -> "Phase 1: Batch Analysis";
    "Phase 1: Batch Analysis" -> "User approves batches";
    "User approves batches" -> "Phase 2: Execute Batch" [label="approved"];
    "User approves batches" -> "Phase 1: Batch Analysis" [label="adjust"];
    "Phase 2: Execute Batch" -> "Phase 3: Parallel Validation";
    "Phase 3: Parallel Validation" -> "All 3 pass?";
    "All 3 pass?" -> "Phase 4: Human Checkpoint" [label="yes"];
    "All 3 pass?" -> "Fix issues" [label="no"];
    "Fix issues" -> "Fix cycles < 3?";
    "Fix cycles < 3?" -> "Phase 3: Parallel Validation" [label="yes"];
    "Fix cycles < 3?" -> "Escalate to user" [label="no"];
    "Escalate to user" -> "Phase 4: Human Checkpoint";
    "Phase 4: Human Checkpoint" -> "More batches?";
    "More batches?" -> "Phase 2: Execute Batch" [label="continue"];
    "More batches?" -> "Completion" [label="done"];
}
```

## Phase 1: Batch Analysis

**Purpose:** Group tasks into batches where each batch leaves the codebase in a buildable, testable state.

### Dispatch Batch Analyzer

```
Task(description: "Analyze plan for batch boundaries",
     prompt: "[Use batch-analyzer-prompt.md template]",
     model: "haiku",
     subagent_type: "general-purpose")
```

**Analyzer Input:**
- Full plan document text
- Project file structure (`tree -L 2`)
- Build system detection (package.json, Cargo.toml, pyproject.toml, etc.)

**Analyzer Output:**
```markdown
## Proposed Batches

### Batch 1 (Tasks 1-3)
- Task 1: Create data model
- Task 2: Add database migration
- Task 3: Implement repository layer
**Rationale:** Creates complete data layer that can be built and tested independently.

### Batch 2 (Tasks 4-5)
- Task 4: Add API endpoint
- Task 5: Add request validation
**Rationale:** Adds HTTP layer on top of data layer.
```

### User Approval Flow

Present proposed batches via AskUserQuestion:

```
AskUserQuestion(
  questions: [{
    question: "Proposed batch boundaries based on buildability. How do you want to proceed?",
    header: "Batches",
    options: [
      {label: "Approve", description: "Accept these batch boundaries"},
      {label: "Adjust", description: "I want to specify different groupings"}
    ],
    multiSelect: false
  }]
)
```

If user selects "Adjust":
- Ask for free-text description of desired changes
- Re-dispatch analyzer with adjustments
- Present new boundaries for approval

<verification>
### Batch Analysis Gate

Before proceeding to execution:

- [ ] Analyzer dispatched with plan + file structure + build system
- [ ] User approved batch boundaries via AskUserQuestion
- [ ] Batches documented in progress file

Proceeding without user-approved batches defeats the intelligent batching purpose.
</verification>