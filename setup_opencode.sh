#!/bin/bash

# OpenCode Installation and Configuration for GLM Coding Plan
# This sets up OpenCode to use your GLM subscription

set -e

echo "=================================="
echo "Setting up OpenCode with GLM Coding Plan"
echo "=================================="
echo ""

# Step 1: Install OpenCode
echo "Step 1: Installing OpenCode..."
if ! command -v opencode &> /dev/null; then
    echo "Installing OpenCode..."
    curl -fsSL https://opencode.ai/install.sh | bash
else
    echo "OpenCode already installed: $(which opencode)"
fi

# Step 2: Configure GLM
echo ""
echo "Step 2: Configuring GLM Coding Plan..."
echo ""
echo "Now run these commands:"
echo ""
echo "1. opencode auth login"
echo "2. Select 'Zhipu AI'"
echo "3. Enter your Z.AI API key (get it from https://z.ai/manage-apikey/apikey-list)"
echo ""
echo "Then configure the coding plan endpoint in ~/.config/opencode/opencode.json:"
echo ""
cat << 'EOF'
{
  "providers": {
    "zhipu": {
      "apiKey": "your-api-key-here",
      "baseURL": "https://api.z.ai/api/coding/paas/v4",
      "models": {
        "glm-4.5": {
          "model": "glm-4.5",
          "maxTokens": 4096,
          "temperature": 0.7
        },
        "glm-4.5-air": {
          "model": "glm-4.5-air",
          "maxTokens": 4096,
          "temperature": 0.7
        }
      }
    }
  },
  "agents": {
    "coder": {
      "model": "zhipu/glm-4.5",
      "maxTokens": 4096
    }
  }
}
EOF

echo ""
echo "After configuration, run 'opencode' and use '/models' to select GLM-4.5"
