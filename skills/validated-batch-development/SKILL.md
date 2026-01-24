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