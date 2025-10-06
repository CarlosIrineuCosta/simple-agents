# Multi-LLM Orchestration System

## Overview
This system provides unified access to multiple AI models through their CLI tools, with intelligent routing to select the best model for each task. All interactions happen through CLIs - no direct API calls!

## Supported LLMs

### 1. GLM (Zhipu AI)
- **Cost**: Subscription-based ($3-15/month, fixed cost)
- **Strengths**: Cost-effective coding, Chinese language
- **Endpoint**: `https://api.z.ai/api/coding/paas/v4`
- **Models**: glm-4.5, glm-4.5-air

### 2. Codex (OpenAI)
- **Cost**: Pay-per-use
- **Strengths**: Complex reasoning, mathematics, general coding
- **CLI**: Installed via npm
- **Models**: gpt-4, gpt-4o-mini

### 3. Gemini (Google)
- **Cost**: Pay-per-use
- **Strengths**: Fast responses, multimodal (images), efficiency
- **CLI**: Installed via npm
- **Models**: gemini-1.5-pro, gemini-1.5-flash

### 4. Claude (Anthropic)
- **Cost**: Pay-per-use
- **Strengths**: Complex orchestration, architecture design
- **Status**: Placeholder (can add CLI wrapper if needed)

## Architecture

```
User → orchestrator.py → [Analyzes task] → Routes to best LLM:
                                           ├─ GLM (via glm_cli.py)
                                           ├─ Codex (via codex_wrapper.sh → codex CLI)
                                           ├─ Gemini (via gemini_wrapper.sh → gemini CLI)
                                           └─ Claude (placeholder)
```

**Key Point**: All LLMs are accessed via CLI tools, NOT direct API calls!

## Installation

```bash
# 1. Install CLI tools (if not already installed)
npm install -g @google-ai/gemini-cli
npm install -g @anthropic/codex

# 2. Clone/navigate to this directory
cd simple-agents

# 3. Run setup
chmod +x setup.sh
./setup.sh

# 4. Set your API keys
export GLM_API_KEY='your-glm-key'
export OPENAI_API_KEY='your-openai-key'
export GEMINI_API_KEY='your-gemini-key'

# 5. Test everything
./test.sh
```

## Files Included

### GLM Components
- `glm_cli.py` - Python CLI for GLM (makes HTTP requests)
- `glm_wrapper.sh` - Bash wrapper for GLM
- `glm.exp` - Expect script for GLM

### Gemini Components
- `gemini_wrapper.sh` - Bash wrapper for Gemini CLI
- `gemini.exp` - Expect script for Gemini

### Codex Components
- `codex_wrapper.sh` - Bash wrapper for Codex CLI
- `codex.exp` - Expect script for Codex

### Orchestration
- `orchestrator.py` - Intelligent task routing between all LLMs
- `setup.sh` - Automated setup script
- `test.sh` - Test suite to verify everything works

## Usage Examples

### Direct CLI Usage

```bash
# GLM (cost-effective)
python3 glm_cli.py "Write a Python function"
./glm_wrapper.sh "Debug this code"

# Gemini (fast, multimodal)
./gemini_wrapper.sh "Explain this concept"
gemini "Quick question"

# Codex (strong reasoning)
./codex_wrapper.sh "Solve this algorithm"
codex exec "Complex logic problem"
```

### Intelligent Orchestration (Recommended)

```bash
# Automatically routes to the best LLM
python3 orchestrator.py "Your task here"

# Routing logic:
# → GLM: Coding tasks, Chinese language, cost-effective
# → Codex: Complex reasoning, math, OpenAI-specific
# → Gemini: Fast queries, multimodal, Google-specific
# → Claude: Complex orchestration, architecture design
```

### Model Selection

```bash
# Set preferred models
export GLM_MODEL=glm-4.5-air
export CODEX_MODEL=gpt-4o-mini
export GEMINI_MODEL=gemini-1.5-flash

# Then use any wrapper
./gemini_wrapper.sh "Your prompt"
```

### GLM-Specific Features

```bash
# Interactive mode
python3 glm_cli.py

# Thinking mode (step-by-step reasoning)
python3 glm_cli.py "Solve this" --no-thinking
```

## Integration with Existing Tools

### With Bash Scripts
```bash
#!/bin/bash
# Use orchestrator for automatic routing
response=$(python3 orchestrator.py "Generate a UUID function")
echo "$response" > generated_code.py

# Or call specific LLM
gemini_response=$(./gemini_wrapper.sh "Quick question")
```

### With Expect Scripts
```expect
# GLM via expect
spawn python3 glm_cli.py "Your prompt"
expect eof

# Codex via expect
./codex.exp "Your prompt"
```

### With Python
```python
import subprocess

# Use orchestrator
result = subprocess.run(
    ['python3', 'orchestrator.py', 'Your task'],
    capture_output=True,
    text=True
)
print(result.stdout)

# Or specific LLM
gemini = subprocess.run(['bash', 'gemini_wrapper.sh', 'prompt'])
```

## Cost Comparison

| LLM | Pricing Model | Best For |
|-----|---------------|----------|
| **GLM** | $3-15/month (subscription) | Regular coding, cost savings |
| **Codex** | Pay-per-token | Strong reasoning when needed |
| **Gemini** | Pay-per-token | Fast queries, multimodal |
| **Claude** | Pay-per-token | Complex orchestration |

**Strategy**: Use orchestrator to automatically route to GLM for most tasks (subscription = fixed cost), while using others for specific strengths.

## Troubleshooting

### CLI Not Found
```bash
# Check which CLIs are installed
which gemini
which codex

# Install if missing
npm install -g @google-ai/gemini-cli
npm install -g @anthropic/codex
```

### API Keys Not Set
```bash
# Set all API keys
export GLM_API_KEY='your-glm-key'
export OPENAI_API_KEY='your-openai-key'
export GEMINI_API_KEY='your-gemini-key'

# Make permanent (add to ~/.bashrc or ~/.zshrc)
echo "export GLM_API_KEY='your-key'" >> ~/.bashrc
source ~/.bashrc
```

### Wrapper Scripts Not Executable
```bash
chmod +x gemini_wrapper.sh codex_wrapper.sh glm_wrapper.sh
chmod +x gemini.exp codex.exp glm.exp
```

### Orchestrator Routes Incorrectly
- Check API keys are set for available LLMs
- Review routing keywords in `orchestrator.py` analyze_task()
- Manually specify LLM if needed (use direct wrapper)

## Important Notes

1. **CLI-Based Architecture**: This system calls CLI binaries, not APIs directly
2. **GLM is Different**: GLM uses Python wrapper (glm_cli.py) that makes HTTP calls
3. **Gemini & Codex**: These use actual CLI binaries installed via npm
4. **Cost Optimization**: Orchestrator defaults to GLM for cost savings

## Next Steps

1. Install CLI tools: `npm install -g @google-ai/gemini-cli @anthropic/codex`
2. Run setup: `./setup.sh`
3. Set API keys (see above)
4. Test: `./test.sh`
5. Start orchestrating: `python3 orchestrator.py "Your task"`

## Resources

- GLM Documentation: https://docs.z.ai
- GLM API Keys: https://z.ai/manage-apikey/apikey-list
- Gemini CLI: https://ai.google.dev/
- Codex/OpenAI: https://platform.openai.com/
