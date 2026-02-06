# Skipping Signs for Team-Driven Development

## Signs the agent is skipping or shortcutting the skill

1. **Implementing tasks directly instead of spawning teammates** — The lead should delegate implementation to teammates, not do it itself
2. **Skipping parallelization planning** — Jumping straight to implementation without analyzing task dependencies
3. **Not cleaning up teams between phases** — Spawning a new team without cleaning up the previous one
4. **Using Task() dispatch instead of agent teams** — Reverting to isolated subagents instead of collaborative teams
5. **Not requiring plan approval for implementation teammates** — Letting teammates start coding without lead verifying file boundaries
6. **Skipping review phase entirely** — Going from implementation directly to build/test
7. **Not tracking fix cycles** — Allowing unlimited fix attempts without escalation
8. **Running all phases as a single team** — Not respecting the one-team-per-phase lifecycle
9. **Not committing between phases** — Next team may see inconsistent git state
10. **Doing serial execution** — Implementing tasks one at a time instead of in parallel batches
