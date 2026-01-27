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

## Installation

**Requires:** Claude Code 1.0.33 or later

### Quick Install

**From terminal:**
```bash
claude plugin marketplace add bradwindy/hyperpowers
claude plugin install hyperpowers@hyperpowers-marketplace
```

**From Claude Code REPL:**
```
/plugin marketplace add bradwindy/hyperpowers
/plugin install hyperpowers@hyperpowers-marketplace
```

### Verify Installation

```
/help
```

You should see skills like `/hyperpowers:brainstorm`, `/hyperpowers:write-plan`, etc.

**Note:** Skills may not appear in `/help` due to a [known issue](https://github.com/anthropics/claude-code/issues/17271), but they still work when invoked directly.

### Local Development

Clone the repository and add it as a local marketplace:

```bash
git clone https://github.com/bradwindy/hyperpowers.git
claude plugin marketplace add ./hyperpowers
claude plugin install hyperpowers@hyperpowers-marketplace
```

**Refreshing after local changes:**

```bash
rm -rf ~/.claude/plugins/cache/hyperpowers-marketplace/
```

Then restart Claude Code. The skill hot-reload feature (v2.1.0+) only applies to `~/.claude/skills/` directories, not marketplace plugins.

### Other Platforms

- **Codex:** See [docs/hyperpowers/README.codex.md](docs/hyperpowers/README.codex.md)
- **OpenCode:** See [docs/hyperpowers/README.opencode.md](docs/hyperpowers/README.opencode.md)

## Key Improvements

Hyperpowers includes significant enhancements over the original [Superpowers](https://github.com/obra/superpowers) project:

| Improvement | Description |
|-------------|-------------|
| Enhanced Planning Workflow | Clarification phase with explicit context gathering and synthesis |
| Subagent-Driven Development | Fresh subagent per task with two-stage review (spec + code quality) |
| Skill Strengthening & Enforcement | `allowed-tools` frontmatter restricts tool access per skill phase |
| Model Selection Optimization | Haiku for validation, Sonnet/Opus for implementation |
| Research Skill | 8+ parallel agents for comprehensive technical research |
| Knowledge Management | Auto-captures debugging solutions to searchable knowledge base |
| Specialized Code Review | 4 parallel reviewers (security, performance, style, test) |
| Context Fork Integration | Isolated investigations reduce token usage by 40-50% |
| Issue Tracking Abstraction | Single agent abstracts beads, GitHub Issues, and Jira MCP |
| Issue Context Preservation | Issue context flows through entire workflow chain |
| Skill Instruction Following | Research-backed reinforcement patterns prevent shortcutting |
| Assumption Validation | Validates design assumptions before planning |
| Research 8-Agent Enforcement | Counter-rationalization prevents agent reduction |
| Test Infrastructure | Comprehensive skill testing with case-insensitive assertions |
| Upstream Merges | Regular sync with Superpowers upstream improvements |

For complete details, see [IMPROVEMENTS.md](IMPROVEMENTS.md).

## Troubleshooting

### Plugin Not Loading / Skills Not Appearing

**Symptoms:** `/help` doesn't show hyperpowers skills, or invoking skills fails.

**Cause:** Plugin cache may be stale or corrupted.

**Solution:**
```bash
rm -rf ~/.claude/plugins/cache/
claude plugin install hyperpowers@hyperpowers-marketplace
```

Then restart Claude Code.

### Plugin Updates Not Taking Effect

**Symptoms:** Running `/plugin update` but not seeing new features or fixes.

**Cause:** Known bugs in Claude Code plugin caching ([#14061](https://github.com/anthropics/claude-code/issues/14061), [#19197](https://github.com/anthropics/claude-code/issues/19197), [#15642](https://github.com/anthropics/claude-code/issues/15642)).

**Solution:**
```bash
rm -rf ~/.claude/plugins/cache/
claude plugin install hyperpowers@hyperpowers-marketplace
```

### Commands Not Showing in /help

**Symptoms:** Skills work when invoked directly, but don't appear in `/help` output.

**Cause:** Namespace visibility bug ([#17271](https://github.com/anthropics/claude-code/issues/17271)).

**Solution:** This is a known Claude Code issue. Skills still work—invoke them directly:
```
/hyperpowers:brainstorm
/hyperpowers:write-plan
/hyperpowers:execute-plan
```

### Local Development Changes Not Reflected

**Symptoms:** Edited skill files locally but changes don't appear in Claude Code.

**Cause:** Marketplace plugins are cached. Skill hot-reload (v2.1.0+) only applies to `~/.claude/skills/` directories.

**Solution:**
```bash
rm -rf ~/.claude/plugins/cache/hyperpowers-marketplace/
```

Then restart Claude Code.

## Contributing

1. Fork the repository
2. Create a branch for your skill or improvement
3. Follow the `writing-skills` skill (`/hyperpowers:writing-skills`) for creating and testing new skills
4. Run tests: `./tests/claude-code/run-skill-tests.sh`
5. Submit a PR

See `skills/writing-skills/SKILL.md` for the complete guide.

## Updating

```bash
/plugin update hyperpowers
```

**Note:** Due to caching issues, you may need to clear the cache manually:
```bash
rm -rf ~/.claude/plugins/cache/
claude plugin install hyperpowers@hyperpowers-marketplace
```

## Sponsorship

If Hyperpowers has helped you do stuff that makes money and you are so inclined, please consider [sponsoring my opensource work](https://github.com/sponsors/bradwindy).

Thanks!

- Bradley