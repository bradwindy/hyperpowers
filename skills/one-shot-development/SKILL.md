---
name: one-shot-development
description: Use when executing plans without checkpoints, running build and test only at completion
allowed-tools: Bash, Read, Grep, Glob, Write, Edit, AskUserQuestion
---

# One-Shot Development

Execute all plan tasks sequentially without human checkpoints, then run build and test phases with fix loops.

**Core principle:** Trust the plan. Execute everything, validate at the end.

**Warning:** This mode is NOT recommended for most use cases. Use only when:
- The plan is well-tested and unambiguous
- You trust the agent to execute without oversight
- You want minimal interaction during implementation

<requirements>
## Requirements

1. Execute all tasks without human checkpoints. Pausing defeats one-shot purpose.
2. Run build phase with fix loops (max 3 cycles). Unlimited loops risk infinite execution.
3. Ask user before proceeding to test phase. Build success is a natural checkpoint.
4. Invoke finishing-a-development-branch at completion. Standard completion pattern.
</requirements>
