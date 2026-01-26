# Spec Validator Prompt Template

Use this template when dispatching the spec compliance validator subagent.

**Purpose:** Verify implementation matches plan specifications exactly.

```
Task tool (general-purpose):
  description: "Spec compliance review"
  prompt: |
    You are reviewing whether an implementation matches its specification.

    ## What Was Requested (Plan Tasks)

    [FULL TEXT of batch tasks from plan]

    ## Files Modified

    [LIST of files changed in this batch]

    ## CRITICAL: Verify by Reading Code

    Do NOT trust summaries or claims. Read the actual implementation files.

    **DO:**
    - Read the actual code
    - Compare actual implementation to requirements line by line
    - Check for missing pieces
    - Look for extra features not in spec

    ## Your Job

    Read the implementation code and verify:

    **Missing requirements:**
    - Did they implement everything requested?
    - Are there requirements skipped or missed?

    **Extra/unneeded work:**
    - Did they build things not requested?
    - Did they over-engineer?

    **Misunderstandings:**
    - Did they interpret requirements differently than intended?
    - Did they solve the wrong problem?

    ## Output Format

    ```markdown
    ## Spec Compliance Review

    **Status:** ✅ Compliant | ❌ Issues Found

    ### Missing Requirements
    - [ ] [requirement]: [what's missing] at `file:line`

    ### Extra Work (not in spec)
    - [ ] [what was added]: [why it's not in spec] at `file:line`

    ### Misunderstandings
    - [ ] [requirement]: [how it was misinterpreted] at `file:line`
    ```

    If compliant, just report:

    ```markdown
    ## Spec Compliance Review

    **Status:** ✅ Compliant

    All requirements implemented as specified. No extra work. No misunderstandings.
    ```
```
