# APR Experiments - Executive Summary

> **Status:** Active - Core workflow validated
> **Last Updated:** 2026-01-27
> **Owner:** Claude Code agent

## TL;DR

**Oracle + remote Chrome works.** Both spec refinement AND research queries successful.

Key command:
```bash
npx -y @steipete/oracle --remote-chrome localhost:9222 --engine browser -m "5.2 Thinking" --file ... -p "..."
```

---

## What Works

| Test | Result |
|------|--------|
| Oracle with remote Chrome | ✅ Stable |
| 5.2 Thinking model | ✅ Works |
| File attachments (inline) | ✅ Works |
| Spec review prompts | ✅ High quality output |
| Research queries | ✅ High quality output |
| APR workflow configs | ✅ Parsed correctly |
| APR robot mode | ✅ JSON API works |

---

## Critical Setup

1. **Node 22 required** - Oracle uses `styleText` from `node:util`
   ```bash
   eval "$(mise activate bash)"
   ```

2. **Chrome with remote debugging** - Avoids login/cookie issues
   ```bash
   "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
     --remote-debugging-port=9222 \
     --user-data-dir="$HOME/.chrome-oracle" \
     "https://chatgpt.com" &
   ```

3. **Login once manually** - Session persists in `~/.chrome-oracle/`

---

## Sample Results

**Spec Review (38 seconds):**
- Input: 261 tokens (2 small files)
- Output: 1,090 tokens (102 lines)
- Quality: 6 concrete improvements with diffs

**Research Query:**
- Asked about convergence vs fixed-iteration
- Got 3 detailed trade-offs with examples
- Quality: Nuanced analysis with failure modes

---

## Known Issues

| Issue | Workaround |
|-------|------------|
| Node 20 = SyntaxError | Use mise Node 22 |
| Oracle browser crashes on login | Use `--remote-chrome` |
| Cookie path doesn't apply | Use `--remote-chrome` |
| APR robot_show looks in wrong dir | Read output files directly |

---

## Next Steps

1. [ ] Test multi-round convergence
2. [ ] Integrate remote-chrome into APR config
3. [ ] Build cfos_research_tool provider using this pattern
4. [ ] Test Extended Thinking time limits

---

## Files Created

- `docs/ORACLE-APR-GUIDE.md` - Comprehensive reference
- `runs/test-basic/round_1.md` - Sample spec review output
- `scripts/start-chrome-oracle.sh` - Chrome startup script
