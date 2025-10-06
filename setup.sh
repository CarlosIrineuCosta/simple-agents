#!/bin/bash

# Complete Setup Script for Multi-LLM Orchestration

set -e

echo "========================================"
echo "Multi-LLM Orchestration Setup"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Check Python
echo -e "${BLUE}Step 1: Checking Python...${NC}"
if command -v python3 &> /dev/null; then
    echo -e "${GREEN}✓ Python3 found: $(python3 --version)${NC}"
else
    echo -e "${RED}✗ Python3 not found. Please install Python 3.6+${NC}"
    exit 1
fi

# Step 2: Install Python dependencies
echo -e "${BLUE}Step 2: Installing Python dependencies...${NC}"
pip3 install requests --user 2>/dev/null || pip3 install requests

# Step 3: Check for CLIs
echo -e "${BLUE}Step 3: Checking for installed CLIs...${NC}"
if command -v gemini &> /dev/null; then
    echo -e "${GREEN}✓ Gemini CLI found${NC}"
else
    echo -e "${YELLOW}⚠ Gemini CLI not found (install: npm install -g @google-ai/gemini-cli)${NC}"
fi

if command -v codex &> /dev/null; then
    echo -e "${GREEN}✓ Codex CLI found${NC}"
else
    echo -e "${YELLOW}⚠ Codex CLI not found (install: npm install -g @anthropic/codex)${NC}"
fi

# Step 4: Check for API keys
echo -e "${BLUE}Step 4: Checking for API keys...${NC}"
if [ -z "$GLM_API_KEY" ]; then
    echo -e "${YELLOW}⚠ GLM_API_KEY not set${NC}"
    echo "  Get your key from: https://z.ai/manage-apikey/apikey-list"
else
    echo -e "${GREEN}✓ GLM_API_KEY is set${NC}"
fi

if [ -z "$OPENAI_API_KEY" ]; then
    echo -e "${YELLOW}⚠ OPENAI_API_KEY not set (needed for Codex)${NC}"
else
    echo -e "${GREEN}✓ OPENAI_API_KEY is set${NC}"
fi

if [ -z "$GEMINI_API_KEY" ]; then
    echo -e "${YELLOW}⚠ GEMINI_API_KEY not set${NC}"
else
    echo -e "${GREEN}✓ GEMINI_API_KEY is set${NC}"
fi

# Step 5: Make scripts executable
echo -e "${BLUE}Step 5: Making scripts executable...${NC}"
chmod +x glm_wrapper.sh
chmod +x glm.exp
chmod +x gemini_wrapper.sh
chmod +x gemini.exp
chmod +x codex_wrapper.sh
chmod +x codex.exp
echo -e "${GREEN}✓ All scripts are executable${NC}"

# Step 6: Test the setup
echo ""
echo -e "${BLUE}Step 6: Testing GLM CLI...${NC}"
if [ ! -z "$GLM_API_KEY" ]; then
    echo "Testing with a simple prompt..."
    python3 glm_cli.py "Say 'Hello, GLM is working!'" --no-thinking
else
    echo -e "${YELLOW}Skipping test (no API key)${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}Setup Complete!${NC}"
echo "=========================================="
echo ""
echo "Available LLMs:"
echo "  - GLM (subscription-based, cost-effective)"
echo "  - Codex (OpenAI, strong reasoning)"
echo "  - Gemini (Google, fast and multimodal)"
echo "  - Claude (complex orchestration)"
echo ""
echo "Usage Examples:"
echo ""
echo "1. GLM CLI:"
echo "   python3 glm_cli.py 'Your prompt'"
echo "   ./glm_wrapper.sh 'Your prompt'"
echo ""
echo "2. Gemini CLI:"
echo "   ./gemini_wrapper.sh 'Your prompt'"
echo "   gemini 'Your prompt'"
echo ""
echo "3. Codex CLI:"
echo "   ./codex_wrapper.sh 'Your prompt'"
echo "   codex exec 'Your prompt'"
echo ""
echo "4. Intelligent Orchestrator (auto-routes to best LLM):"
echo "   python3 orchestrator.py 'Your task here'"
echo ""
echo "Environment Variables:"
echo "  export GLM_API_KEY='your-glm-key'"
echo "  export OPENAI_API_KEY='your-openai-key'"
echo "  export GEMINI_API_KEY='your-gemini-key'"
echo ""
echo "Model Selection:"
echo "  export GLM_MODEL=glm-4.5-air"
echo "  export CODEX_MODEL=gpt-4o-mini"
echo "  export GEMINI_MODEL=gemini-1.5-flash"
echo ""
