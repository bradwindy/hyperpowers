#!/usr/bin/env bash
# PostCompact hook for hyperpowers plugin
# PostCompact is a side-effects-only hook — no JSON output supported.
# Context re-injection after compaction is handled by SessionStart (matcher: "compact").
set -euo pipefail
exit 0
