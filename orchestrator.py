#!/usr/bin/env python3
"""
LLM Orchestrator - Intelligently route tasks to different LLMs
Supports: GLM, OpenAI, Gemini, Claude
"""

import os
import sys
import json
import subprocess
import requests
from typing import Dict, List, Optional

class LLMOrchestrator:
    def __init__(self):
        self.glm_api_key = os.environ.get('GLM_API_KEY', '')
        self.openai_api_key = os.environ.get('OPENAI_API_KEY', '')
        self.gemini_api_key = os.environ.get('GEMINI_API_KEY', '')
        self.claude_api_key = os.environ.get('ANTHROPIC_API_KEY', '')

    def analyze_task(self, task: str) -> Dict[str, any]:
        """Analyze task to determine best LLM to use"""

        # Simple heuristics for task routing
        task_lower = task.lower()

        # Keywords for each LLM
        glm_keywords = ['chinese', '中文', 'subscription', 'cheap', 'cost-effective']
        codex_keywords = ['gpt', 'openai', 'reasoning', 'complex logic', 'math', 'codex']
        gemini_keywords = ['fast', 'quick', 'image', 'multimodal', 'google']
        claude_keywords = ['architecture', 'design', 'multi-file', 'project',
                          'orchestrate', 'coordinate', 'complex']

        # Generic coding keywords (any LLM can handle)
        coding_keywords = ['code', 'function', 'class', 'debug', 'fix', 'refactor',
                          'algorithm', 'implement']

        # Score each LLM
        glm_score = sum(1 for kw in glm_keywords if kw in task_lower)
        codex_score = sum(1 for kw in codex_keywords if kw in task_lower)
        gemini_score = sum(1 for kw in gemini_keywords if kw in task_lower)
        claude_score = sum(1 for kw in claude_keywords if kw in task_lower)
        coding_score = sum(1 for kw in coding_keywords if kw in task_lower)

        # Determine complexity
        complexity = 'simple' if len(task.split()) < 20 else 'complex'

        # Make routing decision
        scores = {
            'glm': glm_score,
            'codex': codex_score,
            'gemini': gemini_score,
            'claude': claude_score
        }

        max_score = max(scores.values())

        # If there's a clear winner based on keywords
        if max_score > 0:
            winner = max(scores.items(), key=lambda x: x[1])[0]

            if winner == 'glm':
                return {
                    'llm': 'glm',
                    'reason': 'Task matches GLM strengths (cost-effective coding)',
                    'complexity': complexity,
                    'model': 'glm-4.5' if complexity == 'complex' else 'glm-4.5-air'
                }
            elif winner == 'codex':
                return {
                    'llm': 'codex',
                    'reason': 'Task requires strong reasoning (Codex/OpenAI)',
                    'complexity': complexity,
                    'model': 'gpt-4' if complexity == 'complex' else 'gpt-4o-mini'
                }
            elif winner == 'gemini':
                return {
                    'llm': 'gemini',
                    'reason': 'Task benefits from fast/multimodal processing (Gemini)',
                    'complexity': complexity,
                    'model': 'gemini-1.5-pro' if complexity == 'complex' else 'gemini-1.5-flash'
                }
            else:  # claude
                return {
                    'llm': 'claude',
                    'reason': 'Task requires complex orchestration (Claude)',
                    'complexity': complexity
                }

        # For coding tasks without specific LLM preference
        if coding_score > 0:
            # Default to GLM for cost savings on coding
            return {
                'llm': 'glm',
                'reason': 'Coding task - using GLM for cost efficiency',
                'complexity': complexity,
                'model': 'glm-4.5' if complexity == 'complex' else 'glm-4.5-air'
            }

        # Default: use Gemini for fast general tasks
        return {
            'llm': 'gemini',
            'reason': 'General task - using Gemini for speed',
            'complexity': complexity,
            'model': 'gemini-1.5-flash'
        }
    
    def call_glm(self, prompt: str, model: str = 'glm-4.5') -> str:
        """Call GLM via CLI"""
        try:
            result = subprocess.run(
                ['python3', 'glm_cli.py', prompt, '--model', model],
                capture_output=True,
                text=True,
                timeout=60
            )

            if result.returncode == 0:
                return result.stdout.strip()
            else:
                return f"Error calling GLM: {result.stderr}"

        except subprocess.TimeoutExpired:
            return "GLM call timed out"
        except Exception as e:
            return f"Error: {str(e)}"

    def call_codex(self, prompt: str, model: str = 'gpt-4') -> str:
        """Call Codex (OpenAI) via CLI wrapper"""
        try:
            env = os.environ.copy()
            env['CODEX_MODEL'] = model

            result = subprocess.run(
                ['bash', 'codex_wrapper.sh', prompt],
                capture_output=True,
                text=True,
                env=env,
                timeout=60
            )

            if result.returncode == 0:
                return result.stdout.strip()
            else:
                return f"Error calling Codex: {result.stderr}"

        except subprocess.TimeoutExpired:
            return "Codex call timed out"
        except Exception as e:
            return f"Error: {str(e)}"

    def call_gemini(self, prompt: str, model: str = 'gemini-1.5-pro') -> str:
        """Call Gemini via CLI wrapper"""
        try:
            env = os.environ.copy()
            env['GEMINI_MODEL'] = model

            result = subprocess.run(
                ['bash', 'gemini_wrapper.sh', prompt],
                capture_output=True,
                text=True,
                env=env,
                timeout=60
            )

            if result.returncode == 0:
                return result.stdout.strip()
            else:
                return f"Error calling Gemini: {result.stderr}"

        except subprocess.TimeoutExpired:
            return "Gemini call timed out"
        except Exception as e:
            return f"Error: {str(e)}"

    def call_claude(self, prompt: str) -> str:
        """Call Claude API"""
        if not self.claude_api_key:
            return "Claude API key not configured"

        # Note: You could also create a claude_cli.py wrapper
        # For now, this is a placeholder
        return f"Claude would handle: {prompt[:50]}..."
    
    def orchestrate(self, task: str) -> Dict[str, any]:
        """Main orchestration logic"""

        # Analyze the task
        routing = self.analyze_task(task)

        print(f"\nTask Analysis:")
        print(f"  - Routing to: {routing['llm'].upper()}")
        print(f"  - Reason: {routing['reason']}")
        print(f"  - Complexity: {routing['complexity']}")

        # Execute based on routing
        if routing['llm'] == 'glm':
            print(f"  - Using model: {routing['model']}")
            print("\nCalling GLM...")
            response = self.call_glm(task, routing['model'])
        elif routing['llm'] == 'codex':
            print(f"  - Using model: {routing['model']}")
            print("\nCalling Codex...")
            response = self.call_codex(task, routing['model'])
        elif routing['llm'] == 'gemini':
            print(f"  - Using model: {routing['model']}")
            print("\nCalling Gemini...")
            response = self.call_gemini(task, routing['model'])
        else:  # claude
            print("\nCalling Claude...")
            response = self.call_claude(task)

        return {
            'routing': routing,
            'response': response
        }

def main():
    if len(sys.argv) < 2:
        print("Usage: python orchestrator.py <task>")
        print("\nExample tasks:")
        print('  "Write a Python function to sort a list"')
        print('  "Analyze the architecture of this project"')
        print('  "Debug this code and fix any issues"')
        sys.exit(1)
    
    task = ' '.join(sys.argv[1:])
    orchestrator = LLMOrchestrator()
    
    result = orchestrator.orchestrate(task)
    
    print("\nResponse:")
    print("-" * 50)
    print(result['response'])
    print("-" * 50)

    # Log cost information
    print("\nCost Analysis:")
    llm_used = result['routing']['llm']
    if llm_used == 'glm':
        print("  Used GLM Coding Plan (subscription-based, cost-effective)")
    elif llm_used == 'codex':
        print("  Used Codex (OpenAI CLI, pay-per-use)")
    elif llm_used == 'gemini':
        print("  Used Gemini (Google CLI, fast and efficient)")
    else:
        print("  Used Claude (complex orchestration)")

if __name__ == '__main__':
    main()
