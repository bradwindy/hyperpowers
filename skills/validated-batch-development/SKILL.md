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