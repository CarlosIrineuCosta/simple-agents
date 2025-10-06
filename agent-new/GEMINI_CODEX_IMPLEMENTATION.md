# GEMINI & CODEX CLI IMPLEMENTATION PLAN

## What We Discovered
- ✅ **Gemini CLI exists**: `/home/cdc/.nvm/versions/node/v22.14.0/bin/gemini`
- ✅ **Codex CLI exists**: `/home/cdc/.nvm/versions/node/v22.14.0/bin/codex`
- ✅ **Expect installed**: For handling interactive CLIs
- ❌ **Cline**: Not a CLI tool (it's a VSCode extension)

## The Original Plan (What Was Missing)

### 1. GEMINI CLI WRAPPER

**File needed: `gemini_wrapper.sh`**
```bash
#!/bin/bash
# Wrapper for Google's Gemini CLI

# Set API key if needed
export GEMINI_API_KEY="${GEMINI_API_KEY:-your-key}"

# Call Gemini CLI
gemini "$@"
```

**File needed: `gemini.exp`** (Expect script for interactive mode)
```expect
#!/usr/bin/expect -f
set timeout 60
set prompt [lindex $argv 0]

spawn gemini
expect ">" 
send "$prompt\r"
expect ">"
send "exit\r"
expect eof
```

### 2. CODEX CLI WRAPPER

**File needed: `codex_wrapper.sh`**
```bash
#!/bin/bash
# Wrapper for OpenAI Codex CLI

# Set API key
export OPENAI_API_KEY="${OPENAI_API_KEY:-your-key}"

# Call Codex CLI  
codex "$@"
```

**File needed: `codex.exp`** (Expect script)
```expect
#!/usr/bin/expect -f
set timeout 60
set prompt [lindex $argv 0]

spawn codex
expect ">" 
send "$prompt\r"
expect ">"
send "exit\r"
expect eof
```

## How They Should Work

### GEMINI CLI
1. **Check actual syntax**: Run `gemini --help` to see exact commands
2. **Authentication**: May need `gemini auth login` first
3. **Usage patterns**:
   ```bash
   gemini "Your prompt"                    # Direct mode
   gemini chat                            # Interactive mode
   gemini --model gemini-pro "prompt"     # Specific model
   ```

### CODEX CLI (Now OpenCode)
Based on research, "Codex" might actually be **OpenCode**:
1. **Installation**: `npm install -g @openai/codex` or use OpenCode
2. **Configuration**: 
   ```bash
   codex auth login     # or opencode auth login
   codex config set model gpt-4
   ```
3. **Usage**:
   ```bash
   codex "Write a function"
   codex --mode plan "Design a system"
   ```

## Integration with Orchestrator

**Update `orchestrator.py`** to add:

```python
def call_gemini(self, prompt: str) -> str:
    """Call Gemini CLI"""
    try:
        result = subprocess.run(
            ['gemini', prompt],
            capture_output=True,
            text=True,
            timeout=60
        )
        return result.stdout.strip()
    except:
        return "Gemini call failed"

def call_codex(self, prompt: str) -> str:
    """Call Codex/OpenCode CLI"""
    try:
        result = subprocess.run(
            ['codex', prompt],  # or 'opencode'
            capture_output=True,
            text=True,
            timeout=60
        )
        return result.stdout.strip()
    except:
        return "Codex call failed"
```

## What "Something" to Install Was

I asked you to install **expect** - a tool that handles interactive CLI programs:
- Allows automation of CLIs that expect user input
- Handles prompts, passwords, interactive sessions
- Essential for CLIs that don't have direct command modes

## Testing Steps for Claude Code

1. **Test Gemini CLI**:
   ```bash
   gemini --help                    # Check available commands
   gemini --version                 # Verify installation
   gemini "Simple test prompt"      # Test direct mode
   ```

2. **Test Codex/OpenCode**:
   ```bash
   codex --help                     # Check if it's really codex
   opencode --help                  # Or if it's OpenCode
   codex "Write hello world"        # Test direct mode
   ```

3. **Create wrapper scripts** based on actual CLI syntax discovered

4. **Update orchestrator** to include all three LLMs:
   - GLM (✅ done)
   - Gemini (needs implementation)
   - Codex/OpenCode (needs implementation)

## Routing Logic

```python
# In orchestrator.py analyze_task():

if "code" in task and "simple" in assessment:
    return "codex"  # Fast code generation
elif "google" in task or "search" in task:
    return "gemini"  # Google's model, good for search
elif "chinese" in task or "reasoning" in task:
    return "glm"  # GLM excels here
else:
    return "glm"  # Default to cheapest (subscription)
```

## Environment Variables Needed

```bash
# Add to ~/.bashrc or setup.sh:
export GLM_API_KEY='your-glm-key'
export GEMINI_API_KEY='your-google-key'  
export OPENAI_API_KEY='your-openai-key'  # For Codex
```

## Final Test Command

After implementation:
```bash
python3 orchestrator.py "Write a Python function"  # Should route to Codex
python3 orchestrator.py "Search for latest news"   # Should route to Gemini  
python3 orchestrator.py "Explain this in Chinese"  # Should route to GLM
```

## Note for Claude Code
The key is discovering the ACTUAL CLI syntax by running `--help` on each tool, then creating appropriate wrappers. The expect scripts handle interactive modes if needed.
