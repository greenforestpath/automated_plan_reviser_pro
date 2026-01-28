# Integration Actions - Ranked Proposals

> **Generated:** 2026-01-27
> **Purpose:** Actionable next steps based on exploration

---

## Ranking Criteria

- **Confidence:** 0-100% certainty it will work
- **Effort:** Low (hours) / Medium (days) / High (weeks)
- **Impact:** How much value does this create?

---

## Tier 1: High Confidence + Low Effort (Do First)

### A1: Document Node 22 Requirement
**Confidence:** 100% | **Effort:** Low | **Impact:** Unblocks Oracle usage

**Action:**
- Add `mise.toml` to APR with `node = "22"` requirement
- Update DOC_ARCHITECTURE.md with Oracle Node requirement
- Add to research_tool AGENTS.md

**Files to Update:**
- `/Users/personal/Projects/CFWOS/automated_plan_reviser_pro/mise.toml` (create)
- `/Users/personal/Projects/CFWOS/cfwos_meta/DOC_ARCHITECTURE.md` (add note)

**Provenance:** Discovered during Oracle testing - requires Node ≥22, we had v20.10.0

---

### A2: Add APR to PATH
**Confidence:** 100% | **Effort:** Low | **Impact:** Ergonomics

**Action:**
- Symlink `apr` to `~/.local/bin/apr` or add to shell config
- Verify works from any directory

**Command:**
```bash
ln -sf /Users/personal/Projects/CFWOS/automated_plan_reviser_pro/apr ~/.local/bin/apr
```

---

### A3: Create Context Build Agent Tracking Issue
**Confidence:** 100% | **Effort:** Low | **Impact:** Documentation

**Action:**
- Create beads issue for "Build context_build_agent"
- Link to exploration docs

**Provenance:** User decision: "we are going to build our own context_build_agent"

---

## Tier 2: High Confidence + Medium Effort (Do After Tier 1)

### A4: Oracle ChatGPT Provider in research_tool
**Confidence:** 80% | **Effort:** Medium | **Impact:** Better session management

**Action:**
- Replace Playwriter ChatGPT provider with Oracle
- Keep Playwriter for Claude.ai (Oracle doesn't support)

**Files:**
- `/Users/personal/Projects/CFWOS/research_tool/src/providers/chatgpt.ts`

**Provenance:** Integration analysis: Oracle has better Extended Thinking handling

---

### A5: APR Robot Mode Integration
**Confidence:** 85% | **Effort:** Medium | **Impact:** Unified orchestration

**Action:**
- Add `apr robot run` wrapper in research_tool
- Use for spec refinement after triangulation

**Provenance:** Exploration finding: APR's robot mode is designed for agent integration

---

## Tier 3: Medium Confidence + Variable Effort (Needs Experimentation)

### A6: Research Query Template for APR
**Confidence:** 60% | **Effort:** Low | **Impact:** Novel use case

**Action:**
- Create research-oriented prompt template
- Test if convergence algorithm applies

**Depends On:** Experiments E11, E12, E13

**Provenance:** User question: "can APR work for research, not just spec refinement?"

---

### A7: Shared Browser Session State
**Confidence:** 40% | **Effort:** High | **Impact:** Efficiency

**Action:**
- Investigate if Oracle and Playwriter can share browser sessions
- Avoid multiple logins

**Status:** Future work - needs more research

---

## Tier 4: Low Confidence / High Effort (Defer)

### A8: Unified Browser Automation Layer
**Confidence:** 30% | **Effort:** High | **Impact:** Architecture cleanup

**Action:**
- Extract common Playwright patterns from Oracle + Playwriter
- Single abstraction for all web AI automation

**Status:** Nice to have, not urgent

---

### A9: Headless Context Build Agent
**Confidence:** 50% | **Effort:** High | **Impact:** VPS/CI support

**Action:**
- Build RepoPrompt replacement that works headless
- Uses code analysis, not GUI

**Depends On:** Golden output collection (manual RepoPrompt usage)

---

## Summary Table

| ID | Action | Confidence | Effort | Status |
|----|--------|------------|--------|--------|
| A1 | Node 22 requirement doc | 100% | Low | Ready |
| A2 | APR to PATH | 100% | Low | Ready |
| A3 | Context agent issue | 100% | Low | Ready |
| A4 | Oracle ChatGPT provider | 80% | Medium | After experiments |
| A5 | APR robot integration | 85% | Medium | After experiments |
| A6 | Research query template | 60% | Low | Experiment needed |
| A7 | Shared browser sessions | 40% | High | Defer |
| A8 | Unified browser layer | 30% | High | Defer |
| A9 | Headless context agent | 50% | High | Defer |

---

## Quick Wins (Can do in 30 min)

1. ✓ Created experiment_sandbox folder structure
2. □ Symlink apr to PATH
3. □ Create beads issue for context_build_agent
4. □ Run E01 (basic setup verification)
