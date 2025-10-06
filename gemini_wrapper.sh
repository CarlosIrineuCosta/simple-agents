#!/bin/bash

# Gemini CLI Wrapper for orchestration
# Calls the actual Gemini CLI binary installed via npm

# Default model
MODEL="${GEMINI_MODEL:-gemini-1.5-pro}"

# Function to call Gemini
call_gemini() {
    local prompt="$1"

    # Call Gemini CLI in non-interactive mode
    gemini -m "$MODEL" "$prompt"
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <prompt>"
    echo "Or run interactively: $0 interactive"
    exit 1
fi

if [ "$1" = "interactive" ]; then
    gemini -m "$MODEL"
else
    call_gemini "$1"
fi
