# Hyperpowers

A complete software development workflow plugin for Claude Code. Hyperpowers guides your coding agent through brainstorming, research, planning, and execution—ensuring systematic, high-quality development instead of ad-hoc code generation.

Your agent doesn't jump into writing code. It asks what you're building, helps refine the design, researches technical approaches, creates detailed implementation plans, and executes tasks with built-in review gates.

## Workflow

Hyperpowers follows a 4-phase workflow that activates automatically based on what you're doing.

### 1. Brainstorming (`/brainstorm`)

Activates when you start any creative work—creating features, building components, adding functionality.

- Explores your current project context (files, docs, recent commits)
- Asks clarifying questions one at a time using multiple choice when possible
- Proposes 2-3 different approaches with trade-offs
- Presents design in sections of 200-300 words for validation
- Saves validated design to `docs/hyperpowers/designs/`

### 2. Research (`/research`)

Activates after brainstorming to gather deep technical context before planning.

- Dispatches 8+ parallel research agents simultaneously
- **Codebase analyst**: Architecture patterns, similar implementations, dependencies
- **Git history analyzer**: Code evolution, past decisions, contributor expertise
- **Framework docs researcher**: Official documentation, API details, version considerations
- **Best practices researcher**: Community patterns, security considerations, common pitfalls
- Additional agents for error handling, test coverage, architecture boundaries, dependencies
- Saves synthesized findings to `docs/hyperpowers/research/`

### 3. Writing Plans (`/write-plan`)

Activates with approved design to create detailed implementation plans.

- Breaks work into bite-sized tasks (2-5 minutes each)
- Every task has exact file paths, complete code, verification steps
- Follows TDD: write failing test → implement minimal code → verify pass → commit
- References research findings in plan header
- Saves plan to `docs/hyperpowers/plans/`

### 4. Execution (`/execute-plan`)

Activates with a plan to implement tasks. Choose from three approaches:

| Approach | Description | Best For |
|----------|-------------|----------|
| **Batch** | Human checkpoints after each batch of tasks | Maximum control |
| **Validated Batch** | 3 parallel validators (build, spec, quality) + human checkpoints | Balance of speed and quality |
| **Subagent** | Fresh agent per task with automated two-stage review | Faster, less interaction |
