#!/bin/bash

# Test: execute-plan router verification
# Fast test - verifies skill routes correctly

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Testing execute-plan router ==="

# Test 1: Skill file exists
echo "Test 1: Skill file exists..."
SKILL_FILE="$SCRIPT_DIR/../../skills/execute-plan/SKILL.md"
if [[ ! -f "$SKILL_FILE" ]]; then
    echo "FAIL: Skill file not found at $SKILL_FILE"
    exit 1
fi
echo "PASS: Skill file exists"

# Test 2: Description mentions execution
echo "Test 2: Description..."
if ! grep -q "executing an implementation plan" "$SKILL_FILE"; then
    echo "FAIL: Description not mentioning execution"
    exit 1
fi
echo "PASS: Description correct"

# Test 3: Choice is COMPULSORY
echo "Test 3: COMPULSORY choice..."
assert_contains "$(cat "$SKILL_FILE")" "COMPULSORY" "COMPULSORY keyword"
assert_contains "$(cat "$SKILL_FILE")" "Never skip" "Never skip instruction"
echo "PASS: Choice is COMPULSORY"

# Test 4: Both options documented
echo "Test 4: Both execution options..."
assert_contains "$(cat "$SKILL_FILE")" "batch-development" "batch-development option"
assert_contains "$(cat "$SKILL_FILE")" "subagent-driven-development" "subagent-driven-development option"
echo "PASS: Both options documented"

# Test 5: Batch size argument documented
echo "Test 5: Batch size argument..."
assert_contains "$(cat "$SKILL_FILE")" "batch-size" "batch-size argument"
echo "PASS: Batch size argument documented"

# Test 6: Red Flags table present
echo "Test 6: Red Flags table..."
assert_contains "$(cat "$SKILL_FILE")" "Red Flags" "Red Flags section"
assert_contains "$(cat "$SKILL_FILE")" "Skipping the choice" "Skip warning"
echo "PASS: Red Flags table present"

echo ""
echo "=== All execute-plan router tests passed ==="
