# Test Scenario: Team-Driven Development

## Setup
- Test project with implementation plan containing 3+ tasks
- At least 2 tasks can be parallelized (no file overlap)
- CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 set

## Trigger
Execute the plan using team-driven-development approach

## Expected Behavior
1. Parallelization planner produces batch groupings
2. Implementation team spawned for first batch
3. Review team spawned after implementation team cleaned up
4. Build/test/fix team spawned after review team cleaned up
5. Cycle repeats for subsequent batches
6. Completion phase runs after all batches done
