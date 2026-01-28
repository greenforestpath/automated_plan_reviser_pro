# APR Experiments - Critical Evaluation & Selection

> **Generated:** 2026-01-27
> **Method:** Systematic evaluation against value criteria

---

## Evaluation Criteria

For each experiment:
1. **Learn:** What do we hope to learn?
2. **Value:** Why is this valuable?
3. **Success:** What happens if it works?
4. **Failure:** What do we do if it fails?

---

## REJECTED Experiments (with reasons)

| ID | Experiment | Rejection Reason |
|----|------------|------------------|
| E04 | simple-spec | Redundant with E06 (real-spec) |
| E05 | robot-mode | Can test incrementally during other experiments |
| E08 | include-impl | Nice-to-have, not core question |
| E09 | round-diff | Tooling, not learning |
| E14 | research-convergence | Depends on E13, premature optimization |
| E15 | research-vs-spec | Complex, save for later |
| E16 | oracle-in-rt | Premature - test APR first |
| E18-20 | integration experiments | Future work after basics proven |
| E21-25 | prompt engineering | Optimization before validation |
| E26-28 | workflow variations | Edge cases, test later |
| E29 | external-context | Feature request, not experiment |

---

## SELECTED Experiments (8 total, ordered by dependency)

### Phase 1: Foundation (Must pass before continuing)

#### E01: Basic APR Setup
**Learn:** Does APR work at all on this machine with current environment?
**Value:** Blocks everything else. 5 minutes to run.
**Success Path:** Move to E02
**Failure Path:** Debug environment (Node version, Oracle availability, etc.)

**Concrete Steps:**
```bash
cd /Users/personal/Projects/CFWOS/automated_plan_reviser_pro
./apr robot status              # Check environment
./apr robot init                # Already done, verify
mkdir -p experiment_sandbox/fixtures
# Create minimal test files
```

**Confidence:** 95% (we already verified most of this)

---

#### E02: Dry Run Inspection
**Learn:** What exactly does APR send to Oracle/GPT Pro?
**Value:** Understanding the input format enables prompt engineering
**Success Path:** Move to E03
**Failure Path:** Debug workflow config

**Concrete Steps:**
```bash
# Create minimal workflow
cat > .apr/workflows/test-basic.yaml << 'EOF'
name: test-basic
description: Minimal test workflow

documents:
  readme: experiment_sandbox/fixtures/test-readme.md
  spec: experiment_sandbox/fixtures/test-spec.md

oracle:
  model: "5.2 Thinking"

rounds:
  output_dir: experiment_sandbox/runs/test-basic

template: |
  Review this specification and suggest improvements.

  README:
  <readme content will be inserted>

  SPECIFICATION:
  <spec content will be inserted>
EOF

./apr run 1 -w test-basic --dry-run
```

**Confidence:** 90%

---

#### E03: Oracle Connection Test
**Learn:** Can Oracle actually connect to ChatGPT in browser mode?
**Value:** Critical path - if this fails, nothing works
**Success Path:** Move to E06
**Failure Path:** Debug Oracle (login, browser profile, etc.)

**Concrete Steps:**
```bash
# Direct Oracle test (bypassing APR)
eval "$(mise activate bash)"
npx -y @steipete/oracle --engine browser \
  -m "5.2" \
  --browser-manual-login \
  -p "Say hello" \
  --dry-run summary

# If that works, try actual submission (SHORT prompt)
# WARNING: This costs quota
```

**Confidence:** 70% (browser automation is fragile)

---

### Phase 2: Core Validation

#### E06: Real Spec Refinement (Native Use Case)
**Learn:** Does APR's core use case work on a real specification?
**Value:** Validates the entire value proposition
**Success Path:** Capture output, move to E10
**Failure Path:** Analyze what went wrong, iterate

**Concrete Steps:**
```bash
# Use research_tool's types.ts as spec (small, real)
cp /Users/personal/Projects/CFWOS/research_tool/src/core/types.ts \
   experiment_sandbox/fixtures/research-tool-types.md

# Create workflow
cat > .apr/workflows/rt-types.yaml << 'EOF'
name: rt-types
description: Refine research_tool type definitions

documents:
  readme: /Users/personal/Projects/CFWOS/research_tool/README.md
  spec: experiment_sandbox/fixtures/research-tool-types.md

oracle:
  model: "5.2 Thinking"

rounds:
  output_dir: experiment_sandbox/runs/rt-types

template: |
  Review these TypeScript type definitions for a research tool.
  Suggest improvements for:
  - Type safety
  - Clarity and naming
  - Missing types or fields
  - Architectural patterns

  README (context):
  <readme>

  TYPE DEFINITIONS:
  <spec>
EOF

./apr run 1 -w rt-types --wait
```

**Confidence:** 75%

---

#### E10: Integration Prompt Generation
**Learn:** Does `apr integrate` produce usable Claude Code prompts?
**Value:** Direct integration with our workflow
**Success Path:** Document the integration pattern
**Failure Path:** Understand what's missing, propose fixes

**Concrete Steps:**
```bash
# After E06 produces output
./apr integrate 1 -w rt-types --copy
# Paste into Claude Code, evaluate usefulness
```

**Confidence:** 85% (mostly a formatting question)

---

### Phase 3: Novel Use Case (Research Queries)

#### E11: Research-Oriented Template
**Learn:** Can we write a prompt template that works for research questions?
**Value:** Core hypothesis of "APR for research" feasibility
**Success Path:** Move to E12
**Failure Path:** Understand why spec template doesn't generalize

**Concrete Steps:**
```yaml
# .apr/workflows/research-query.yaml
name: research-query
description: Research question exploration

documents:
  readme: experiment_sandbox/fixtures/project-context.md
  spec: experiment_sandbox/fixtures/research-question.md

oracle:
  model: "5.2 Thinking"

rounds:
  output_dir: experiment_sandbox/runs/research-query

template: |
  You are a research assistant. Answer this question thoroughly.

  PROJECT CONTEXT:
  <readme>

  RESEARCH QUESTION:
  <spec>

  Provide:
  1. Direct answer with evidence
  2. Alternative perspectives
  3. Uncertainties and gaps
  4. Recommended next steps
```

**Confidence:** 80%

---

#### E12: Single Research Round
**Learn:** Does GPT Pro Extended Thinking produce useful research output?
**Value:** Validates APR for non-spec use cases
**Success Path:** Analyze output quality, compare to manual ChatGPT
**Failure Path:** Understand what's different about research vs spec

**Test Question:**
```markdown
# Research Question

What are the tradeoffs between using browser automation (Playwright/Oracle)
vs direct API access for interacting with AI models like ChatGPT?

Consider:
- Reliability
- Cost (API credits vs compute)
- Feature access (Extended Thinking)
- Maintenance burden
- Legal/TOS considerations
```

**Confidence:** 75%

---

#### E13: Multi-Round Research
**Learn:** Do multiple rounds improve research quality like they improve specs?
**Value:** Determines if iteration helps for research
**Success Path:** Document the iteration pattern for research
**Failure Path:** Conclude research is single-shot, adjust strategy

**Concrete Steps:**
```bash
./apr run 1 -w research-query --wait
./apr run 2 -w research-query --wait
./apr run 3 -w research-query --wait
./apr diff 1 2 -w research-query
./apr diff 2 3 -w research-query
./apr stats -w research-query
```

**Confidence:** 60% (uncertain if iteration helps)

---

### Phase 4: Integration (After Phase 1-3 Succeed)

#### E17: APR Robot in research_tool
**Learn:** Can research_tool call APR programmatically?
**Value:** Enables unified orchestration
**Success Path:** Document integration code, propose architecture
**Failure Path:** Identify blockers, propose workarounds

**Concrete Code:**
```typescript
// research_tool/src/providers/apr.ts
import { $ } from 'bun';

export async function callAPR(round: number, workflow: string) {
  const result = await $`apr robot run ${round} -w ${workflow}`.json();

  if (!result.ok) {
    throw new Error(`APR failed: ${result.code}`);
  }

  return {
    slug: result.data.slug,
    outputFile: result.data.output_file,
    status: result.data.status
  };
}
```

**Confidence:** 85%

---

## Experiment Dependency Graph

```
E01 (setup)
  └── E02 (dry-run)
        └── E03 (oracle-connection)
              ├── E06 (real-spec) ──► E10 (integrate)
              │
              └── E11 (research-template)
                    └── E12 (single-research)
                          └── E13 (multi-round-research)
                                └── E17 (apr-robot-integration)
```

---

## Resource Requirements

| Experiment | Oracle Calls | Est. Time | Quota Cost |
|------------|--------------|-----------|------------|
| E01 | 0 | 2 min | Free |
| E02 | 0 | 5 min | Free |
| E03 | 1 | 15 min | Minimal |
| E06 | 1 | 30-60 min | 1 Extended Thinking |
| E10 | 0 | 5 min | Free |
| E11 | 0 | 10 min | Free |
| E12 | 1 | 30-60 min | 1 Extended Thinking |
| E13 | 3 | 90-180 min | 3 Extended Thinking |
| E17 | 0 | 30 min | Free |

**Total Quota Cost:** 5 Extended Thinking sessions

---

## Decision Point

After E03 (oracle-connection), we'll know if browser automation works.

**If works:** Proceed with E06, E11-E13
**If fails:** Pivot to:
- Debug Oracle setup
- Consider API-only mode
- Consider manual paste workflow
