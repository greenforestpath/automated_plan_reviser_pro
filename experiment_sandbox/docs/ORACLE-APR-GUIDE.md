# Oracle + APR Integration Guide

> **Version:** 0.1
> **Updated:** 2026-01-27
> **Status:** Working - tested end-to-end

---

## Overview

**Oracle** = Browser automation for ChatGPT (by @steipete)
**APR** = Spec refinement orchestrator that wraps Oracle

Together they enable automated, iterative document refinement via GPT Pro Extended Thinking.

---

## Quick Start (Tested & Working)

### 1. Start Chrome with Remote Debugging

```bash
# First time - creates persistent profile
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  --user-data-dir="$HOME/.chrome-oracle" \
  "https://chatgpt.com" &
```

**Log into ChatGPT manually in that window.** Session persists in `~/.chrome-oracle/`.

### 2. Test Oracle Connection

```bash
eval "$(mise activate bash)"  # Ensure Node 22+

npx -y @steipete/oracle \
  --remote-chrome localhost:9222 \
  --engine browser \
  -m "5.2" \
  --prompt "Say hello" \
  --slug "test connection works"
```

### 3. Run Full Spec Review

```bash
npx -y @steipete/oracle \
  --remote-chrome localhost:9222 \
  --engine browser \
  -m "5.2 Thinking" \
  --file path/to/readme.md \
  --file path/to/spec.md \
  --browser-attachments never \
  --slug "review my spec now" \
  --write-output output.md \
  -p "Review this spec and suggest improvements with diffs."
```

---

## Oracle Command Space

### Execution Modes

| Option | Description |
|--------|-------------|
| `--engine browser` | Automate ChatGPT web UI (default if no API key) |
| `--engine api` | Use OpenAI API directly (needs OPENAI_API_KEY) |
| `--remote-chrome host:port` | Connect to existing Chrome instance |

### Model Selection

| Model | Flag | Notes |
|-------|------|-------|
| GPT 5.2 | `-m "5.2"` | Fast, good for simple queries |
| GPT 5.2 Thinking | `-m "5.2 Thinking"` | Extended reasoning, best for complex tasks |
| GPT 5.2 Pro | `-m "gpt-5.2-pro"` | API only |

### File Handling

| Option | Description |
|--------|-------------|
| `--file path` | Attach file (can repeat) |
| `--file "glob/**/*.ts"` | Glob patterns work |
| `--file "!pattern"` | Exclude pattern |
| `--browser-attachments never` | Paste inline (recommended) |
| `--browser-attachments always` | Upload as files |
| `--browser-attachments auto` | Auto-decide based on size |

### Output Control

| Option | Description |
|--------|-------------|
| `--write-output path.md` | Save response to file |
| `--slug "3-5 word name"` | Session identifier (required format) |
| `--dry-run` | Preview without sending |
| `--render` | Print markdown bundle |
| `--copy` | Copy to clipboard |

### Browser Options

| Option | Description |
|--------|-------------|
| `--browser-manual-login` | Wait for manual login |
| `--browser-keep-browser` | Don't close browser after |
| `--browser-cookie-path path` | Use saved cookies |
| `--chatgpt-url url` | Override ChatGPT URL |
| `--browser-model-strategy select\|current\|ignore` | How to pick model |

### Session Management

```bash
oracle status                    # List recent sessions
oracle status --hours 72         # Longer history
oracle session <slug>            # Attach to session
oracle session <slug> --render   # View with formatting
```

### Debugging & Preview

| Option | Description |
|--------|-------------|
| `--dry-run` | Preview without sending (shows token count) |
| `--render` | Print full prompt bundle |
| `--files-report` | Show token usage per file |
| `--verbose` | Detailed logging |

Example token report:
```
File Token Usage
    61,830    31.55%  large-file.ts
       107     0.05%  small-spec.md
Total: 62,013 tokens (31.64% of 196,000)
```

---

## APR Command Space

### Interactive Commands

```bash
apr setup                     # First-time wizard
apr run <round>              # Run revision round
apr run 1 --login --wait     # First run with manual login
apr status                   # Check Oracle sessions
apr attach <session>         # Attach to running session
apr list                     # List workflows
apr history                  # Show revision history
apr diff <N> [M]             # Compare rounds
apr integrate <round>        # Generate Claude Code prompt
apr dashboard                # Analytics TUI
```

### Robot Mode (JSON API for Agents)

```bash
apr robot status             # {"ok": true, "data": {...}}
apr robot workflows          # List all workflows
apr robot validate <round>   # Pre-run checks
apr robot run <round>        # Execute round
apr robot show <round>       # View round content
apr robot diff <N> [M]       # Compare rounds
apr robot integrate <round>  # Get integration prompt
apr robot history            # List rounds
apr robot stats              # Convergence metrics
```

### Workflow Configuration

File: `.apr/workflows/<name>.yaml`

```yaml
name: my-workflow
description: What this refines

documents:
  readme: path/to/readme.md
  spec: path/to/spec.md
  implementation: path/to/impl.md  # optional

oracle:
  model: "5.2 Thinking"

rounds:
  output_dir: path/to/outputs
  impl_every_n: 3  # Include impl every N rounds

template: |
  Your prompt template here.
  Reference attached files by name.
```

---

## Known Issues

1. **Node Version**: Oracle requires Node 22+ (`styleText` from `node:util`)
   - Fix: `eval "$(mise activate bash)"` before running

2. **robot_show bug**: Looks in `.apr/rounds/` but `run` outputs to configured `output_dir`
   - Workaround: Read output files directly

3. **Browser crash on login**: Oracle's built-in browser can crash during login
   - Fix: Use `--remote-chrome` with pre-authenticated Chrome

4. **Cookie path doesn't work**: `--browser-cookie-path` often fails to apply cookies
   - Fix: Use `--remote-chrome` instead

---

## Integration Patterns

### Pattern 1: Direct Oracle (Simplest)

```bash
# Start Chrome once, reuse forever
./scripts/start-chrome-oracle.sh

# Run queries
npx -y @steipete/oracle --remote-chrome localhost:9222 ...
```

### Pattern 2: APR Workflow (Structured)

```bash
# Setup workflow
apr setup

# Run rounds
apr run 1 --wait
apr run 2 --wait
# ... until converged

# Check convergence
apr robot stats -w myworkflow
```

### Pattern 3: Agent Integration (Robot Mode)

```bash
# Check status
apr robot status

# Run and capture output
apr robot run 1 -w myworkflow > result.json

# Parse result
jq '.data.output' result.json
```

---

## Tested Configurations

| Test | Status | Notes |
|------|--------|-------|
| Oracle + remote Chrome | ✅ Works | Best approach |
| Oracle 5.2 model | ✅ Works | Fast responses |
| Oracle 5.2 Thinking | ✅ Works | Better quality |
| File attachments inline | ✅ Works | Use `--browser-attachments never` |
| APR workflow config | ✅ Works | YAML parsed correctly |
| APR robot status | ✅ Works | JSON output |
| Spec review prompt | ✅ Works | Got 6 improvements with diffs |
| Research query | ✅ Works | Detailed trade-off analysis |

---

## Environment Setup

```bash
# Required: Node 22+
mise install node@22
echo '[tools]\nnode = "22"' > mise.toml

# Activate before running Oracle/APR
eval "$(mise activate bash)"

# Or use mise exec
mise exec -- npx -y @steipete/oracle ...
```

---

## File Locations

| Path | Purpose |
|------|---------|
| `~/.chrome-oracle/` | Persistent Chrome profile with ChatGPT login |
| `~/.local/share/apr/` | APR data directory |
| `.apr/` | Project-local APR config |
| `.apr/workflows/` | Workflow YAML files |
| `mise.toml` | Node version pinning |
