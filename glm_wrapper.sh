#!/bin/bash

# GLM CLI Wrapper for orchestration
# This wrapper makes it easy to call GLM from other scripts

# Check if GLM_API_KEY is set
if [ -z "$GLM_API_KEY" ]; then
    echo "Error: GLM_API_KEY environment variable not set"
    echo "Export your API key: export GLM_API_KEY='your-key-here'"
    exit 1
fi

# Default model
MODEL="${GLM_MODEL:-glm-4.5}"

# Function to call GLM
call_glm() {
    local prompt="$1"
    local thinking="${2:-on}"
    
    if [ "$thinking" = "off" ]; then
        python3 glm_cli.py "$prompt" --model "$MODEL" --no-thinking
    else
        python3 glm_cli.py "$prompt" --model "$MODEL"
    fi
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <prompt> [thinking on|off]"
    echo "Or run interactively: $0 interactive"
    exit 1
fi

if [ "$1" = "interactive" ]; then
    python3 glm_cli.py --model "$MODEL"
else
    call_glm "$1" "${2:-on}"
fi
