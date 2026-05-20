#!/usr/bin/env bash
set -euo pipefail

ROOT="/data/projects/CFOS/automated_plan_reviser_pro"
RUN_DIR="$ROOT/experiment_sandbox/runs/apr_validation"
PROJECT="$RUN_DIR/project"
EMPTY_PROJECT="$RUN_DIR/empty_project"
LOG_DIR="$RUN_DIR/logs"
MOCK_BIN="$RUN_DIR/bin"
APR="$ROOT/apr"

mkdir -p "$LOG_DIR"

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "$LOG_DIR/harness.log"
}

fail() {
  log "FAIL: $*"
  exit 1
}

json_ok() {
  local expr="$1"
  local file="$2"
  jq -e "$expr" <(sed '/^APR_ERROR_CODE=/,$d' "$file") >/dev/null 2>&1
}

run_step() {
  local name="$1"
  shift
  log "RUN $name: $*"
  "$@" > "$LOG_DIR/${name}.out" 2>&1 || {
    log "STEP $name exited non-zero"
    return 1
  }
}

run_step_allow_fail() {
  local name="$1"
  shift
  log "RUN $name: $*"
  "$@" > "$LOG_DIR/${name}.out" 2>&1 || {
    log "STEP $name exited non-zero (allowed)"
    return 0
  }
}

export PATH="$MOCK_BIN:$PATH"
export APR_NO_NPX=1
export APR_NO_GUM=1

log "L0: version"
run_step "L0_version" "$APR" --version
if ! grep -q "apr version" "$LOG_DIR/L0_version.out"; then
  fail "version output missing"
fi

log "L1: robot status (empty project)"
( cd "$EMPTY_PROJECT" && run_step "L1_robot_status_empty" "$APR" robot status )
if ! json_ok '.code == "ok" and .data.configured == false' "$LOG_DIR/L1_robot_status_empty.out"; then
  fail "expected configured=false status"
fi

log "L2: robot status (configured project)"
( cd "$PROJECT" && run_step "L2_robot_status_configured" "$APR" robot status )
if ! json_ok '.code == "ok"' "$LOG_DIR/L2_robot_status_configured.out"; then
  fail "expected ok status"
fi

log "L2b: robot workflows (configured project)"
( cd "$PROJECT" && run_step "L2b_robot_workflows" "$APR" robot workflows )
if ! json_ok '.code == "ok" and (.data.workflows[] | .name == "apr-validation")' "$LOG_DIR/L2b_robot_workflows.out"; then
  fail "expected workflow list to include apr-validation"
fi

log "L2c: robot validate (configured project)"
( cd "$PROJECT" && run_step "L2c_robot_validate" "$APR" robot validate 1 )
if ! json_ok '.code == "ok" and (.data.valid == true)' "$LOG_DIR/L2c_robot_validate.out"; then
  fail "expected valid=true from robot validate"
fi

log "L3: render"
( cd "$PROJECT" && run_step "L3_render" "$APR" run 1 --render )
if ! grep -q "Mock prompt content" "$LOG_DIR/L3_render.out"; then
  fail "render output missing mock content"
fi

log "L3b: list workflows"
( cd "$PROJECT" && run_step "L3b_list" "$APR" list )
if ! grep -q "apr-validation" "$LOG_DIR/L3b_list.out"; then
  fail "list output missing workflow"
fi

log "L3c: status"
( cd "$PROJECT" && run_step "L3c_status" "$APR" status )
if ! grep -qi "No active sessions" "$LOG_DIR/L3c_status.out"; then
  fail "status output missing oracle status"
fi

log "L4: dry-run"
( cd "$PROJECT" && run_step "L4_dry_run" "$APR" run 1 --dry-run )
if ! grep -q -- "--browser-attachments never" "$LOG_DIR/L4_dry_run.out"; then
  fail "dry-run missing browser-attachments flag"
fi

log "L5: run (mock)"
( cd "$PROJECT" && run_step "L5_run" "$APR" run 1 )
if [[ ! -f "$PROJECT/.apr/rounds/apr-validation/round_1.md" ]]; then
  fail "round_1.md not created"
fi
if ! grep -q "Mock output" "$PROJECT/.apr/rounds/apr-validation/round_1.md"; then
  fail "round_1.md missing mock output"
fi

log "L5b: robot run (mock)"
( cd "$PROJECT" && run_step_allow_fail "L5b_robot_run" "$APR" robot run 1 )
if ! json_ok '(.code == "ok") or (.code == "validation_failed" and .data.kind == "output_exists")' "$LOG_DIR/L5b_robot_run.out"; then
  fail "expected ok or output_exists from robot run"
fi

log "L5c: history"
( cd "$PROJECT" && run_step "L5c_history" "$APR" history )
if ! grep -q "Round 1" "$LOG_DIR/L5c_history.out"; then
  fail "history output missing Round 1"
fi

log "L5d: integrate"
( cd "$PROJECT" && run_step "L5d_integrate" "$APR" integrate 1 )
if ! grep -q "round_1" "$LOG_DIR/L5d_integrate.out"; then
  fail "integrate output missing round reference"
fi

log "OK: All ladder steps passed"
