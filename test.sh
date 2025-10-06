#!/bin/bash

# Test Script for Multi-LLM Orchestration
# Tests all components of the system

set -e

echo "============================================"
echo "Multi-LLM Orchestration Test Suite"
echo "============================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local command="$2"
    
    echo -e "${BLUE}Test: $test_name${NC}"
    
    if eval "$command" &> /dev/null; then
        echo -e "${GREEN}  ✓ PASSED${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}  ✗ FAILED${NC}"
        ((TESTS_FAILED++))
    fi
}

# Test 1: Check Python
run_test "Python installed" "command -v python3"

# Test 2: Check requests module
run_test "Requests module" "python3 -c 'import requests'"

# Test 3: Check for CLI tools
echo -e "${BLUE}Checking CLI tools...${NC}"
run_test "Gemini CLI installed" "command -v gemini"
run_test "Codex CLI installed" "command -v codex"

# Test 4: Check API keys
echo -e "${BLUE}Checking API keys...${NC}"
# Test GLM_API_KEY
if [ ! -z "$GLM_API_KEY" ]; then
    echo -e "${GREEN}  ✓ GLM_API_KEY is set${NC}"
    ((TESTS_PASSED++))
    
    # Test 4: Test GLM CLI directly
    echo -e "${BLUE}Test: GLM CLI direct call${NC}"
    if python3 glm_cli.py "Return only: TEST_OK" --no-thinking 2>&1 | grep -q "TEST_OK"; then
        echo -e "${GREEN}  ✓ PASSED${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}  ✗ FAILED${NC}"
        ((TESTS_FAILED++))
    fi
    
    # Test 5: Test GLM wrapper script
    echo -e "${BLUE}Test: GLM Wrapper script${NC}"
    if [ -x glm_wrapper.sh ]; then
        echo -e "${GREEN}  ✓ GLM Wrapper is executable${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}  ✗ GLM Wrapper not executable${NC}"
        ((TESTS_FAILED++))
    fi

else
    echo -e "${YELLOW}  ⚠ GLM_API_KEY not set - skipping GLM tests${NC}"
    echo "  Set it with: export GLM_API_KEY='your-key-here'"
fi

# Test Gemini
if [ ! -z "$GEMINI_API_KEY" ] && command -v gemini &> /dev/null; then
    echo -e "${GREEN}  ✓ GEMINI_API_KEY is set${NC}"
    ((TESTS_PASSED++))

    run_test "Gemini wrapper executable" "[ -x gemini_wrapper.sh ]"
else
    echo -e "${YELLOW}  ⚠ GEMINI_API_KEY not set or Gemini CLI not installed${NC}"
fi

# Test Codex
if [ ! -z "$OPENAI_API_KEY" ] && command -v codex &> /dev/null; then
    echo -e "${GREEN}  ✓ OPENAI_API_KEY is set${NC}"
    ((TESTS_PASSED++))

    run_test "Codex wrapper executable" "[ -x codex_wrapper.sh ]"
else
    echo -e "${YELLOW}  ⚠ OPENAI_API_KEY not set or Codex CLI not installed${NC}"
fi

# Test orchestrator routing
echo -e "${BLUE}Test: Orchestrator routing${NC}"
if python3 orchestrator.py "Write a simple function" 2>&1 | grep -qE "(GLM|GEMINI|CODEX)"; then
    echo -e "${GREEN}  ✓ Orchestrator routes correctly${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}  ✗ Orchestrator routing failed${NC}"
    ((TESTS_FAILED++))
fi

# Test 7: Check expect
if command -v expect &> /dev/null; then
    echo -e "${GREEN}  ✓ Expect is installed${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${YELLOW}  ⚠ Expect not installed (optional)${NC}"
fi

echo ""
echo "=================================="
echo "Test Results"
echo "=================================="
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed! System is ready.${NC}"
else
    echo -e "${YELLOW}Some tests failed. Please check the setup.${NC}"
fi

echo ""
echo "Quick Start Examples:"
echo "--------------------"
echo ""
echo "1. GLM (cost-effective coding):"
echo "   python3 glm_cli.py 'Write a Python hello world'"
echo ""
echo "2. Gemini (fast, multimodal):"
echo "   ./gemini_wrapper.sh 'Explain this image'"
echo ""
echo "3. Codex (OpenAI reasoning):"
echo "   ./codex_wrapper.sh 'Solve this math problem'"
echo ""
echo "4. Auto-routed orchestration:"
echo "   python3 orchestrator.py 'Debug this function: def add(a,b): return a-b'"
echo ""
