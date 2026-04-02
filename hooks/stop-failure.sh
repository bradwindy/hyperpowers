#!/usr/bin/env bash
# StopFailure hook for hyperpowers plugin
# Saves progress state when API errors interrupt workflows.
# Output and exit code are ignored by Claude Code — this hook is for side effects only.

set -euo pipefail

# Check for active progress file and log failure context
progress_file="docs/hyperpowers/current-progress.md"
if [ -f "$progress_file" ]; then
    # Progress file exists — workflow was in progress when failure occurred.
    # The file persists on disk for recovery in the next session.
    :
fi

exit 0
