# Oracle Quick Reference

## Setup (One Time)
```bash
# 1. Start Chrome with debug port
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  --user-data-dir="$HOME/.chrome-oracle" \
  "https://chatgpt.com" &

# 2. Login to ChatGPT manually

# 3. Activate Node 22
eval "$(mise activate bash)"
```

## Basic Query
```bash
npx -y @steipete/oracle \
  --remote-chrome localhost:9222 \
  -m "5.2" \
  -p "Your question here" \
  --slug "three to five words"
```

## With Files (Spec Review)
```bash
npx -y @steipete/oracle \
  --remote-chrome localhost:9222 \
  -m "5.2 Thinking" \
  --file readme.md \
  --file spec.md \
  --browser-attachments never \
  --write-output output.md \
  --slug "review my spec now" \
  -p "Review and suggest improvements"
```

## Preview Without Sending
```bash
npx -y @steipete/oracle --dry-run --files-report --file ... -p "..."
```

## Check Sessions
```bash
oracle status              # List all
oracle session <slug>      # View output
```

## APR Robot Mode
```bash
apr robot status           # Check setup
apr robot run 1            # Run round 1
apr robot show 1           # View output
apr robot stats            # Convergence metrics
```

## Common Flags
| Flag | Purpose |
|------|---------|
| `-m "5.2 Thinking"` | Extended reasoning model |
| `--browser-attachments never` | Paste files inline |
| `--write-output file.md` | Save response |
| `--dry-run` | Preview only |
| `--files-report` | Show token usage |
