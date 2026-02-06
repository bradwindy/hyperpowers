#!/usr/bin/env bash
# Compliance test for the team-driven-development skill
# Tests that Claude:
# 1. Runs parallelization planner before team phases
# 2. Spawns implementation team with plan approval
# 3. Cleans up teams between phases (one team per session)
# 4. Spawns review team with cross-domain discussion
# 5. Spawns build/test/fix team with coordinated cycles
# 6. Tracks fix cycles with 3-strike escalation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

SKILL_NAME="team-driven-development"
SCENARIO_FILE="$SCRIPT_DIR/skills/$SKILL_NAME/scenario.md"
CHECKLIST_FILE="$SCRIPT_DIR/skills/$SKILL_NAME/checklist.md"
SKIPPING_FILE="$SCRIPT_DIR/skills/$SKILL_NAME/skipping-signs.md"
BASELINE_FILE="$SCRIPT_DIR/skills/$SKILL_NAME/baseline-capture.md"
TEST_PROJECT="/tmp/hyperpowers-test-app"

echo "=== Compliance Test: $SKILL_NAME ==="
echo ""

# Verify test project exists
if [ ! -d "$TEST_PROJECT" ]; then
    echo "[ERROR] Test project not found at $TEST_PROJECT"
    echo "Run Task 17 to create the test project first"
    exit 1
fi

# Verify required files exist
for file in "$SCENARIO_FILE" "$CHECKLIST_FILE" "$SKIPPING_FILE" "$BASELINE_FILE"; do
    if [ ! -f "$file" ]; then
        echo "[ERROR] Required file not found: $file"
        exit 1
    fi
done

echo "Test project verified at $TEST_PROJECT"
echo ""

# Step 0: Create the implementation plan with parallelizable tasks
echo "Step 0: Setting up implementation plan with parallelizable tasks..."

cd "$TEST_PROJECT"

# Clean up any existing test artifacts
rm -rf docs/hyperpowers/plans/ docs/hyperpowers/current-progress.md docs/hyperpowers/parallelization-plan.md docs/hyperpowers/handoffs/ 2>/dev/null || true

# Create the plan directory and file
mkdir -p docs/hyperpowers/plans

cat > docs/hyperpowers/plans/team-test-plan.md << 'PLAN_EOF'
# Implementation Plan: Multi-Component Feature

**Goal:** Add three independent UI components

**Architecture:** React components, no shared state

**Tech Stack:** Next.js, TypeScript, React Testing Library

---

## Task 1: Create Header component

**Files:**
- Create: src/components/Header.tsx
- Create: src/components/Header.test.tsx

**Steps:**
1. Create Header.tsx with title prop
2. Render title in h1 element
3. Write test for component rendering

**Commit:** feat: add Header component

---

## Task 2: Create Footer component

**Files:**
- Create: src/components/Footer.tsx
- Create: src/components/Footer.test.tsx

**Steps:**
1. Create Footer.tsx with copyright year prop
2. Render copyright message
3. Write test for component rendering

**Commit:** feat: add Footer component

---

## Task 3: Create Sidebar component

**Files:**
- Create: src/components/Sidebar.tsx
- Create: src/components/Sidebar.test.tsx

**Steps:**
1. Create Sidebar.tsx with items array prop
2. Render list of items
3. Write test for component rendering

**Commit:** feat: add Sidebar component

---

## Task 4: Integrate components into page

**Files:**
- Modify: src/app/page.tsx
- Modify: src/app/page.test.tsx

**Steps:**
1. Import all three components
2. Add to page layout
3. Write integration test

**Context from Tasks 1-3:** All three components exist

**Commit:** feat: integrate Header, Footer, Sidebar into homepage
PLAN_EOF

mkdir -p src/components

echo "Implementation plan created with 3 parallelizable tasks + 1 dependent task"
echo ""

# Step 1: Run scenario executing the plan with team-driven approach
echo "Step 1: Running team-driven-development scenario..."
echo "(This will use agent teams - may take 15-25 minutes)"
echo ""

USER_PROMPT="Execute the plan at docs/hyperpowers/plans/team-test-plan.md using team-driven development approach"

# Run Claude in the test project directory
# High max-turns needed for: planner + 3 team phases + cycling
SESSION_OUTPUT=$(claude -p "$USER_PROMPT" --max-turns 60 2>&1 || true)
cd "$SCRIPT_DIR"

# Debug: show session output length
echo "Session output captured (${#SESSION_OUTPUT} chars)"
if [ ${#SESSION_OUTPUT} -lt 500 ]; then
    echo "[WARNING] Session output seems too short. Full output:"
    echo "$SESSION_OUTPUT"
    echo ""
fi
echo ""

# Step 2: Prepare reviewer prompt
echo "Step 2: Preparing reviewer prompt..."

CHECKLIST=$(cat "$CHECKLIST_FILE")
SKIPPING_SIGNS=$(cat "$SKIPPING_FILE")

REVIEWER_PROMPT=$(cat "$SCRIPT_DIR/reviewer-prompt-template.md")
REVIEWER_PROMPT="${REVIEWER_PROMPT//\{SESSION_OUTPUT\}/$SESSION_OUTPUT}"
REVIEWER_PROMPT="${REVIEWER_PROMPT//\{CHECKLIST\}/$CHECKLIST}"
REVIEWER_PROMPT="${REVIEWER_PROMPT//\{SKIPPING_SIGNS\}/$SKIPPING_SIGNS}"
REVIEWER_PROMPT="${REVIEWER_PROMPT//\{SKILL_NAME\}/$SKILL_NAME}"

echo "Reviewer prompt prepared"
echo ""

# Step 3: Dispatch reviewer agent
echo "Step 3: Dispatching reviewer agent..."
echo "(This will call Claude Haiku for review - may take 30-60 seconds)"
echo ""

VERDICT=$(claude -p "$REVIEWER_PROMPT" --model haiku --max-turns 1 2>&1 || true)

echo "Reviewer verdict received"
echo ""

# Step 4: Check verdict
echo "Step 4: Checking verdict..."
echo ""

echo "--- Reviewer Analysis ---"
if echo "$VERDICT" | grep -q '"checklist_results"'; then
    echo "Checklist Results:"
    echo "$VERDICT" | grep -A 200 '"checklist_results"' | head -205
fi
echo ""

if echo "$VERDICT" | grep -q '"skipping_observations"'; then
    echo "Skipping Observations:"
    echo "$VERDICT" | grep -A 100 '"skipping_observations"' | head -105
fi
echo ""

if echo "$VERDICT" | grep -q '"reasoning"'; then
    echo "Reasoning:"
    echo "$VERDICT" | grep -A 5 '"reasoning"' | head -7
fi
echo "-------------------------"
echo ""

# Step 5: Cleanup
echo "Step 5: Cleaning up test files..."
cd "$TEST_PROJECT"
rm -rf docs/hyperpowers/plans/ docs/hyperpowers/current-progress.md docs/hyperpowers/parallelization-plan.md docs/hyperpowers/handoffs/ 2>/dev/null || true
rm -rf src/components/Header.tsx src/components/Header.test.tsx 2>/dev/null || true
rm -rf src/components/Footer.tsx src/components/Footer.test.tsx 2>/dev/null || true
rm -rf src/components/Sidebar.tsx src/components/Sidebar.test.tsx 2>/dev/null || true
git checkout -- . 2>/dev/null || true
git reset --hard HEAD~10 2>/dev/null || true
cd "$SCRIPT_DIR"
echo "Cleanup complete"
echo ""

# Determine pass/fail
if echo "$VERDICT" | grep -q '"verdict".*:.*"PASS"'; then
    echo "=== RESULT: PASS ==="
    echo ""
    echo "Team-driven-development skill compliance verified:"
    echo "- Parallelization Planning: Plan produced before teams"
    echo "- Implementation Team: Parallel teammates with plan approval"
    echo "- Review Team: Cross-domain discussion between reviewers"
    echo "- Build/Test/Fix Team: Coordinated fix cycles"
    echo "- Phase Transitions: Clean team lifecycle"
    echo ""
    exit 0
else
    echo "=== RESULT: FAIL ==="
    echo ""
    echo "Team-driven-development skill compliance failed."
    echo ""
    if echo "$VERDICT" | grep -q '"status".*:.*"MISSING"'; then
        echo "Missing checklist items:"
        echo "$VERDICT" | grep -B 1 '"status".*:.*"MISSING"' | grep '"item"' | head -20
    fi
    if echo "$VERDICT" | grep -q '"status".*:.*"OBSERVED"'; then
        echo "Skipping signs observed:"
        echo "$VERDICT" | grep -B 1 '"status".*:.*"OBSERVED"' | grep '"sign"' | head -20
    fi
    echo ""
    exit 1
fi
