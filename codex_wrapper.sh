#!/bin/bash

# Codex CLI Wrapper for orchestration
# Calls the actual Codex CLI binary installed via npm

# Default model
MODEL="${CODEX_MODEL:-gpt-4}"

# Function to call Codex
call_codex() {
    local prompt="$1"

    # Call Codex CLI - exec mode for non-interactive
    codex exec -m "$MODEL" "$prompt"
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <prompt>"
    echo "Or run interactively: $0 interactive"
    exit 1
fi

if [ "$1" = "interactive" ]; then
    codex -m "$MODEL"
else
    call_codex "$1"
fi
