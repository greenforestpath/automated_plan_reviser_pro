# APR Capability Ladder (Fail-Fast, Escalate)

Purpose: provide a deterministic, repeatable escalation path that lets us
validate APR functionality from basic CLI checks to full Oracle-backed runs.

## Ladder Levels

L0. CLI sanity
- Command: `apr --version`, `apr help`
- Pass: version prints, help renders, non-zero exit on invalid flags

L1. Robot status (unconfigured)
- Command: `apr robot status` in empty dir
- Pass: JSON `code=ok`, `data.configured=false`, `workflow_count=0`

L2. Robot status (configured)
- Command: `apr robot status` in configured project
- Pass: JSON `code=ok`, `data.configured=true`, workflow list includes target

L2b. Robot workflows
- Command: `apr robot workflows`
- Pass: JSON includes target workflow

L2c. Robot validate
- Command: `apr robot validate 1`
- Pass: JSON `valid=true`

L3. Render only
- Command: `apr run 1 --render`
- Pass: rendered prompt appears (no Oracle run)

L3b. List workflows
- Command: `apr list`
- Pass: human output includes target workflow

L3c. Oracle status
- Command: `apr status`
- Pass: oracle status output (mock or real)

L4. Dry-run
- Command: `apr run 1 --dry-run`
- Pass: command includes `--browser-attachments never`, slug, write-output

L5. Mock-run
- Command: `apr run 1` with mock oracle in PATH
- Pass: output file exists and contains mock output; no Oracle dependency

L5b. Robot run (mock)
- Command: `apr robot run 1`
- Pass: JSON `code=ok` or `validation_failed` with `output_exists`

L5c. History
- Command: `apr history`
- Pass: output includes `Round 1`

L5d. Integrate
- Command: `apr integrate 1`
- Pass: output includes round reference

L6. Real Oracle run (baseline)
- Command: `apr run 1` with real Oracle + remote Chrome
- Pass: output file populated by Oracle (no truncation), logs saved
- Requires:
  - Oracle CLI installed (global or npx)
  - Remote Chrome (debug port) + logged-in ChatGPT Pro
  - Stable network

L7. Real Oracle run (2nd inquiry)
- Same as L6 but with second inquiry/context pack to catch attachment edge cases

## Notes
- APR uses inline paste by default (`--browser-attachments never`).
- BATS test suite requires `git submodule update --init --recursive`.

## Files
- Harness: `experiment_sandbox/runs/apr_validation/validation_harness.sh`
- Logs: `experiment_sandbox/runs/apr_validation/logs/`
