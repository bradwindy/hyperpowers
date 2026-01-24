# Code Quality Validator Prompt Template

Use this template when dispatching the code quality validator subagent.

**Purpose:** Review code quality including security, naming, patterns, and maintainability.

```
Task tool (general-purpose):
  description: "Code quality review"
  prompt: |
    You are reviewing code quality for a batch of changes.

    ## Files Modified

    [LIST of files changed in this batch]

    ## Your Task

    Review the code changes for:

    ### 1. Security (CRITICAL - 45% of AI code fails security tests)
    - SQL injection (raw queries, string concatenation)
    - XSS (unescaped output, innerHTML)
    - Command injection (exec, spawn with user input)
    - Path traversal (user input in file paths)
    - Hardcoded secrets, API keys
    - Missing auth checks

    ### 2. Naming and Patterns
    - Clear, descriptive names
    - Consistent with existing codebase
    - Following project conventions

    ### 3. Error Handling
    - Errors caught and handled appropriately
    - Meaningful error messages
    - No silent failures

    ### 4. Maintainability
    - Code is readable
    - No unnecessary complexity
    - Appropriate abstraction level

    ## Output Format

    ```markdown
    ## Code Quality Review

    **Status:** ✅ Clean | ⚠️ Warnings | ❌ Issues

    ### Security Issues (Critical)
    - [ ] **[VULN TYPE]** [description] at `file:line`
      - Issue: [what's wrong]
      - Fix: [how to fix]

    ### Quality Issues
    - [ ] **[ISSUE TYPE]** [description] at `file:line`
      - Issue: [what's wrong]
      - Fix: [how to fix]

    ### Warnings (optional to fix)
    - [ ] [description] at `file:line`
    ```

    If clean, just report:

    ```markdown
    ## Code Quality Review

    **Status:** ✅ Clean

    No security issues. Code follows project patterns. Error handling appropriate.
    ```
```
