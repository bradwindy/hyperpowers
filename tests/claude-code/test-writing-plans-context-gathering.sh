#!/usr/bin/env bash
# Test: writing-plans skill should validate requests and check research
# Scenario: User invokes /write-plan for a feature
# Expected: Claude checks for research, validates request clarity
# Baseline behavior: Jumps straight to writing plan without research check
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: writing-plans research check and clarification ==="
echo ""

# Test 1: Verify skill describes the research check
echo "Test 1: Research check phase exists..."

output=$(run_claude "What does the writing-plans skill check for before writing a plan? Describe the phases." 30)

if assert_contains "$output" "research\|Research" "Mentions research check"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "Phase 0\|clarification\|Clarification" "Mentions Phase 0 or clarification"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Verify research directory is docs/hyperpowers/research/
echo "Test 2: Research directory mentioned..."

output=$(run_claude "Where does the writing-plans skill look for research documents?" 30)

if assert_contains "$output" "docs/hyperpowers/research" "Uses docs/hyperpowers/research directory"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: Verify degraded mode exists when no research
echo "Test 3: Degraded mode when no research..."

output=$(run_claude "What happens in the writing-plans skill if no research document is found?" 30)

if assert_contains "$output" "degraded\|ask.*user\|lightweight\|proceed without" "Mentions degraded mode or asks user"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 4: Verify plan saves to docs/hyperpowers/plans/
echo "Test 4: Plan output location..."

output=$(run_claude "Where does the writing-plans skill save the completed plan?" 30)

if assert_contains "$output" "docs/hyperpowers/plans" "Saves to docs/hyperpowers/plans/"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 5: Verify plan header includes Context Gathered From
echo "Test 5: Plan header includes Context Gathered From..."

output=$(run_claude "In the writing-plans skill, what should the plan document header include?" 60)

if assert_contains "$output" "Context Gathered From\|Goal\|Architecture\|Tech Stack" "Has required header sections"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 6: Verify Issue Context phase exists
echo "Test 6: Issue context phase exists..."

output=$(run_claude "Does the writing-plans skill include related issues in the plan? How?" 30)

if assert_contains "$output" "issue\|Issue\|Related Issues\|Original Issue" "Mentions issue context"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 7: Verify Phase 0 clarification process
echo "Test 7: Phase 0 clarification process..."

output=$(run_claude "What is Phase 0 in the writing-plans skill? What does it do?" 30)

if assert_contains "$output" "clarification\|Clarification\|request\|ambiguity\|question" "Mentions request clarification"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 8: Verify codebase-explorer-prompt.md exists and has required sections
echo "Test 8: Codebase explorer prompt template exists..."

PROMPT_FILE="$SCRIPT_DIR/../../skills/writing-plans/codebase-explorer-prompt.md"

if [ ! -f "$PROMPT_FILE" ]; then
    echo "FAIL: codebase-explorer-prompt.md does not exist"
    exit 1
fi

content=$(cat "$PROMPT_FILE")

if echo "$content" | grep -q "Codebase Explorer Subagent Prompt Template"; then
    echo "PASS: Has correct title"
else
    echo "FAIL: Missing correct title"
    exit 1
fi

if echo "$content" | grep -q "Your Exploration Focus"; then
    echo "PASS: Has 'Your Exploration Focus' section"
else
    echo "FAIL: Missing 'Your Exploration Focus' section"
    exit 1
fi

if echo "$content" | grep -q "Write Handoff File"; then
    echo "PASS: Has 'Write Handoff File' section"
else
    echo "FAIL: Missing 'Write Handoff File' section"
    exit 1
fi

if echo "$content" | grep -q "docs/hyperpowers/handoffs/context-codebase-{aspect}.md"; then
    echo "PASS: Specifies correct handoff file path"
else
    echo "FAIL: Missing correct handoff file path"
    exit 1
fi

echo ""

# Test 9: Verify assumption validation section exists
echo "Test 9: Assumption validation mentioned..."

output=$(run_claude "Does the writing-plans skill validate assumptions in the plan?" 30)

if assert_contains "$output" "assumption\|Assumption\|validate\|Validate" "Mentions assumption validation"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All writing-plans tests passed ==="
