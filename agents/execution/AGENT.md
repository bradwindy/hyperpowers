---
name: execution
description: |
  Agents for team-driven development execution phases.
  Dispatched as agent team teammates by the team-driven-development skill.
  Includes parallelization planning, build running, test running, and fix specialist roles.
---

# Execution Agent Group

Agents in this group support the team-driven-development skill's phased team cycle.

## Agents

| Agent | Model | Role |
|-------|-------|------|
| parallelization-planner | haiku | Analyzes implementation plans for parallel execution, produces batch groupings with file boundaries |
| build-runner | haiku | Runs build commands, analyzes errors, communicates with team about failures |
| test-runner | haiku | Runs test suites, analyzes failures, communicates with team about what needs fixing |
| fix-specialist | (inherit) | Receives build/test failure reports, implements fixes, requests re-verification |

## Usage

These agents are spawned as teammates in agent teams, not via `Task()` dispatch.
The team-driven-development skill orchestrates their lifecycle.

## Coordination Pattern

Build/test/fix agents operate as a team:
1. Build Runner starts immediately
2. Test Runner starts after build passes (task dependency)
3. Fix Specialist activates when issues are reported by either runner
4. Cycle: fix -> re-build -> re-test until green (max 3 cycles)
