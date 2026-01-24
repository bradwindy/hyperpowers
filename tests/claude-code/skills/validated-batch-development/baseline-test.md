# Validated Batch Development Baseline Test

## Test: Skill loads and announces correctly

**Given:**
- User invokes: `/hyperpowers:validated-batch-development docs/hyperpowers/plans/test-plan.md`

**Expected behavior:**
1. Skill loads without error
2. Skill dispatches batch analyzer subagent
3. Analyzer returns proposed batches
4. User is asked to approve batches via AskUserQuestion

**Assertions:**
- [ ] Output contains "Phase 1: Batch Analysis" or equivalent
- [ ] Output contains "Task" dispatch for analyzer
- [ ] Output contains "AskUserQuestion" for batch approval
- [ ] Output does NOT contain "fixed batch size" or "batch-size=N"

## Test: Parallel validation dispatch

**Given:**
- User approves batches
- Main agent completes a batch

**Expected behavior:**
1. Three validators dispatched in SINGLE message
2. All validators use haiku model
3. Validators run in parallel

**Assertions:**
- [ ] Single message contains 3 Task calls
- [ ] All Task calls specify model: "haiku"
- [ ] Output does NOT show sequential validator execution

## Test: 3-strike escalation

**Given:**
- Validation fails 3 times

**Expected behavior:**
1. After 3rd failure, escalation to user
2. AskUserQuestion with Continue/Skip/Stop options

**Assertions:**
- [ ] Output contains "3 fix cycles"
- [ ] Output contains AskUserQuestion
- [ ] Options include ability to continue, skip, or stop

## Test: Human checkpoint required

**Given:**
- All validators pass

**Expected behavior:**
1. AskUserQuestion presented with Continue/Feedback/Pause/Stop
2. Does NOT proceed without user response

**Assertions:**
- [ ] Output contains AskUserQuestion after validation
- [ ] Output does NOT show "proceeding to next batch" without user response
