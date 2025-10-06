# GLM CLI Solution - Working Implementation

## What This Is
A complete solution to use your GLM Coding Plan subscription ($3-15/month) via command-line tools, avoiding expensive per-token API pricing.

## Key Files
- `glm_cli.py` - Main Python CLI that calls GLM's coding plan API
- `glm_wrapper.sh` - Bash wrapper for easy scripting integration  
- `orchestrator.py` - Intelligent task router (GLM vs Claude)
- `setup.sh` - Automated setup script
- `test.sh` - Test suite to verify everything works
- `setup_opencode.sh` - Alternative: Use OpenCode terminal tool

## Quick Start

```bash
# 1. Set your API key (get from https://z.ai/manage-apikey/apikey-list)
export GLM_API_KEY='your-api-key-here'

# 2. Run setup
chmod +x setup.sh
./setup.sh

# 3. Test it
python3 glm_cli.py "Say hello"
```

## Why This Works
- Uses special coding plan endpoint: `https://api.z.ai/api/coding/paas/v4`
- You pay subscription ($3-15/month), not per token
- OpenAI-compatible format makes it easy to create CLI wrapper

## Old Files
Previous Claude Code-based orchestration attempt moved to `old_backup/` folder.
Those files tried to use Cline as a CLI (but Cline is a VSCode extension, not a CLI tool).

## This Solution Works!
Tested and ready to use with your GLM Coding Plan subscription.
