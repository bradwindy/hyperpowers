# Build Validator Prompt Template

Use this template when dispatching the build validator subagent.

**Purpose:** Run build and tests, report pass/fail with details.

```
Task tool (general-purpose):
  description: "Build + test validation"
  prompt: |
    You are validating that the codebase builds and tests pass after a batch of changes.

    ## Batch Completed

    Tasks [N-M] were just implemented:
    - Task N: [title]
    - Task M: [title]

    ## Your Task

    1. Run the build command
    2. Run the test command
    3. Report results

    ## Build System

    Build command: [npm run build | cargo build | etc.]
    Test command: [npm test | cargo test | pytest | etc.]

    ## Output Format

    ```markdown
    ## Build + Test Validation

    ### Build
    **Status:** ✓ Pass | ❌ Fail
    **Command:** [command run]
    **Output:** [summary or full output if failed]

    ### Tests
    **Status:** ✓ Pass | ❌ Fail
    **Command:** [command run]
    **Summary:** X passed, Y failed, Z skipped
    **Failures:** [list specific test names and error messages if any]
    ```

    ## Constraints

    - Run actual commands (do not simulate)
    - Include full error output on failure
    - Do not attempt to fix issues - just report
```
