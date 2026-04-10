#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OPENCODE_BIN="$HOME/.opencode/bin/opencode"
OPENCODE_BIN="${OPENCODE_BIN:-}"

workspace=""
prompt_file=""
prompt_inline=""
out_base=""
model=""
agent=""
variant=""

usage() {
  cat <<'EOF'
Usage:
  run_opencode_consult.sh --workspace /abs/workspace [--prompt-file /abs/prompt.md | --prompt "text"]

Options:
  --workspace   Workspace passed to opencode --dir
  --prompt-file Markdown file sent as the consultation prompt
  --prompt      Inline prompt text
  --out-base    Archive base dir (default: <workspace>/docs/ai-handoff/opencode)
  --model       Optional opencode model, e.g. opencode-go/kimi-k2.5
  --agent       Optional opencode agent
  --variant     Optional provider-specific reasoning variant

Environment:
  OPENCODE_BIN  Override the opencode executable path
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workspace)
      workspace="${2:-}"
      shift 2
      ;;
    --prompt-file)
      prompt_file="${2:-}"
      shift 2
      ;;
    --prompt)
      prompt_inline="${2:-}"
      shift 2
      ;;
    --out-base)
      out_base="${2:-}"
      shift 2
      ;;
    --model)
      model="${2:-}"
      shift 2
      ;;
    --agent)
      agent="${2:-}"
      shift 2
      ;;
    --variant)
      variant="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$workspace" ]]; then
  echo "--workspace is required" >&2
  exit 2
fi

if [[ ! -d "$workspace" ]]; then
  echo "workspace does not exist: $workspace" >&2
  exit 2
fi

if [[ -n "$prompt_file" && -n "$prompt_inline" ]]; then
  echo "use either --prompt-file or --prompt" >&2
  exit 2
fi

if [[ -z "$prompt_file" && -z "$prompt_inline" ]]; then
  echo "one of --prompt-file or --prompt is required" >&2
  exit 2
fi

if [[ -z "$OPENCODE_BIN" ]]; then
  if command -v opencode >/dev/null 2>&1; then
    OPENCODE_BIN="$(command -v opencode)"
  else
    OPENCODE_BIN="$DEFAULT_OPENCODE_BIN"
  fi
fi

if [[ ! -x "$OPENCODE_BIN" ]]; then
  echo "opencode binary not executable: $OPENCODE_BIN" >&2
  echo "Set OPENCODE_BIN or add opencode to PATH." >&2
  exit 127
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but missing" >&2
  exit 127
fi

if [[ -n "$prompt_file" && ! -f "$prompt_file" ]]; then
  echo "prompt file missing: $prompt_file" >&2
  exit 2
fi

if [[ -z "$out_base" ]]; then
  out_base="$workspace/docs/ai-handoff/opencode"
fi

mkdir -p "$out_base"

timestamp="$(date '+%Y%m%d-%H%M%S')"
slug_source="$prompt_inline"
if [[ -n "$prompt_file" ]]; then
  slug_source="$(head -n 1 "$prompt_file" 2>/dev/null || true)"
fi
slug="$(printf '%s' "$slug_source" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//; s/-$//' | cut -c1-32)"
if [[ -z "$slug" ]]; then
  slug="consult"
fi

run_dir="$out_base/$timestamp-$slug"
mkdir -p "$run_dir"

if [[ -n "$prompt_file" ]]; then
  cp "$prompt_file" "$run_dir/prompt.md"
else
  printf '%s\n' "$prompt_inline" > "$run_dir/prompt.md"
fi

prompt_content="$(cat "$run_dir/prompt.md")"

cmd=("$OPENCODE_BIN" run "$prompt_content")
cmd+=(--format json --dir "$workspace")
if [[ -n "$model" ]]; then
  cmd+=(--model "$model")
fi
if [[ -n "$agent" ]]; then
  cmd+=(--agent "$agent")
fi
if [[ -n "$variant" ]]; then
  cmd+=(--variant "$variant")
fi

printf '%q ' "${cmd[@]}" > "$run_dir/command.txt"
printf '\n' >> "$run_dir/command.txt"

printf '%s\n' "${cmd[@]}" | jq -R . | jq -s . > "$run_dir/command.json"

jq -n \
  --arg timestamp "$timestamp" \
  --arg workspace "$workspace" \
  --arg archive_dir "$run_dir" \
  --arg model "$model" \
  --arg agent "$agent" \
  --arg variant "$variant" \
  --arg opencode_bin "$OPENCODE_BIN" \
  '{
    timestamp: $timestamp,
    workspace: $workspace,
    archive_dir: $archive_dir,
    model: (if $model == "" then null else $model end),
    agent: (if $agent == "" then null else $agent end),
    variant: (if $variant == "" then null else $variant end),
    opencode_bin: $opencode_bin
  }' > "$run_dir/meta.json"

stdout_file="$run_dir/raw.jsonl"
stderr_file="$run_dir/stderr.log"

set +e
"${cmd[@]}" >"$stdout_file" 2>"$stderr_file"
exit_code=$?
set -e

status="failure"
if [[ $exit_code -eq 0 ]]; then
  status="success"
fi
printf '%s\n' "$status" > "$run_dir/status.txt"

if [[ -s "$stdout_file" ]]; then
  jq -r 'select(.type == "text") | .part.text' "$stdout_file" > "$run_dir/answer.md" 2>/dev/null || true
fi

if [[ ! -s "$run_dir/answer.md" ]]; then
  cat > "$run_dir/answer.md" <<'EOF'
No extracted text answer was captured.
Check raw.jsonl and stderr.log.
EOF
fi

cat > "$run_dir/codex-decision.md" <<EOF
# Codex Decision

- Status: ${status}
- Exit code: ${exit_code}
- Decision: TODO (adopt | reject | verify-separately)
- Reason: TODO

## Notes

- What did OpenCode suggest?
- What will Codex adopt, reject, or verify separately?
- Were there any reliability issues such as TLS, timeout, or empty output?
EOF

if [[ $exit_code -ne 0 ]]; then
  echo "OpenCode consultation failed. Archive: $run_dir" >&2
  exit "$exit_code"
fi

echo "$run_dir"
