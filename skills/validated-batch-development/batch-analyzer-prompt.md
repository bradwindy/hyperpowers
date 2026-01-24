# Batch Analyzer Prompt Template

Use this template when dispatching the batch analyzer subagent.

**Purpose:** Analyze plan tasks and group them into batches based on buildability.

```
Task tool (general-purpose):
  description: "Analyze plan for batch boundaries"
  prompt: |
    You are analyzing an implementation plan to determine optimal batch boundaries.

    ## Plan Document

    [FULL PLAN TEXT]

    ## Project Structure

    [OUTPUT OF: tree -L 2]

    ## Build System

    Detected: [package.json | Cargo.toml | pyproject.toml | Makefile | etc.]
    Build command: [npm run build | cargo build | python -m build | make | etc.]
    Test command: [npm test | cargo test | pytest | make test | etc.]

    ## Your Task

    Group tasks into batches where each batch:
    1. Leaves the codebase in a BUILDABLE state (build command succeeds)
    2. Leaves the codebase in a TESTABLE state (tests can run, may fail on future features)
    3. Contains logically related tasks
    4. Is as small as possible while meeting criteria 1-2

    ## Output Format

    ```markdown
    ## Proposed Batches

    ### Batch 1 (Tasks N-M)
    - Task N: [title]
    - Task M: [title]
    **Rationale:** [Why these tasks form a buildable unit]
    **Build state:** [What will build successfully after this batch]

    ### Batch 2 (Tasks X-Y)
    ...
    ```

    ## Edge Cases

    - **Single-task batch:** Allowed if task is independently buildable
    - **Large batch:** Acceptable if splitting would break buildability
    - **Circular dependencies:** Flag and describe the circular dependency

    ## Constraints

    - Do NOT just split into equal chunks
    - Do NOT ignore build system dependencies
    - DO consider import/require statements and file dependencies
    - DO consider test file dependencies
```
