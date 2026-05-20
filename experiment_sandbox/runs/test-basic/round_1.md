Here are 6 concrete improvements that make the spec less “fortune cookie” and more “engine part.” Each includes: issue → fix → diff.

1) Define what the system is and what “process” means

Issue: “accept/process/return” is content-free. Nobody can implement, test, or refine it without inventing the product in their head.

Fix: Add a Scope + Definitions section: what the system does (APR experiment harness), what “input/output” are, what “process” entails (e.g., transform a text prompt into a result via APR pipeline).

Diff:

diff
Copy code
--- a/experiment_sandbox/fixtures/test-spec.md
+++ b/experiment_sandbox/fixtures/test-spec.md
@@
 # Test Specification v0.1
 
 ## Overview
-This is a deliberately simple specification to test APR's refinement capabilities.
+This is a deliberately simple specification to test APR's refinement capabilities.
+The system is a minimal APR experiment harness that:
+1) accepts a user prompt,
+2) runs a configurable processing pipeline (e.g., APR refine loop and/or research query execution),
+3) returns a structured result suitable for evaluation.
+
+## Scope
+- In scope: single-request execution, deterministic-ish configuration, and observable outputs for evaluation.
+- Out of scope: authentication, multi-user persistence, production-grade scaling, and UI polish.
+
+## Definitions
+- **Input**: user-provided text (prompt) plus optional metadata (mode, constraints).
+- **Process**: an APR-driven refinement/execution pipeline producing an answer + artifacts (logs/metrics).
+- **Output**: machine-readable result payload + human-readable summary.

2) Replace vague requirements with testable, atomic requirements

Issue: “shall process input” can’t be verified. Requirements should be observable and falsifiable.

Fix: Rewrite requirements as explicit behaviors: supported modes (spec-refine vs research), validation, structured outputs, error behavior.

Diff:

diff
Copy code
--- a/experiment_sandbox/fixtures/test-spec.md
+++ b/experiment_sandbox/fixtures/test-spec.md
@@
 ## Requirements
-1. The system shall accept user input
-2. The system shall process input
-3. The system shall return output
+### Functional
+R1. The system shall accept a text prompt and an optional `mode` parameter (`spec_refine` | `research_query`).
+R2. The system shall validate input and reject empty prompts with a structured error.
+R3. In `spec_refine` mode, the system shall run an APR refinement loop over a provided specification document.
+R4. In `research_query` mode, the system shall execute a query workflow and return retrieved sources or evidence summaries (if configured).
+R5. The system shall return a structured result containing:
+    - `status` (success | error)
+    - `mode`
+    - `output_text`
+    - `artifacts` (e.g., diffs, citations, logs)
+    - `metrics` (e.g., iterations, tokens, elapsed_ms)
+
+### Non-Functional
+N1. The system shall emit traceable logs for each run including configuration and iteration outcomes.
+N2. The system shall be deterministic under a fixed seed/config where supported by underlying components.

3) Specify the I/O contract (formats) instead of asking it as an open question

Issue: Leaving input/output formats undefined forces implementers to invent interfaces, which destroys comparability between APR runs.

Fix: Define a minimal request/response schema (even if it’s “v0”). You’re using TypeScript—lean into it.

Diff:

diff
Copy code
--- a/experiment_sandbox/fixtures/test-spec.md
+++ b/experiment_sandbox/fixtures/test-spec.md
@@
 ## Architecture
-``` Input → Process → Output ```
+``` Input → Validate → Execute Pipeline → Package Result ```
+
+## Interfaces
+### Request (v0)
+- `prompt: string` (required)
+- `mode: "spec_refine" | "research_query"` (optional, default: "spec_refine")
+- `spec_text: string` (required for `spec_refine`)
+- `config: { max_iterations?: number; convergence_threshold?: number; seed?: number }` (optional)
+
+### Response (v0)
+- `status: "success" | "error"`
+- `mode: string`
+- `output_text: string`
+- `artifacts: { diffs?: string[]; citations?: string[]; logs?: string[] }`
+- `metrics: { iterations: number; elapsed_ms: number }`
+- `error?: { code: string; message: string; details?: unknown }`

4) Make the architecture structural (components + boundaries), not a slogan

Issue: “Input → Process → Output” is a po
