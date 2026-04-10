---
name: opencode-for-codex
description: Use when Codex needs a second opinion from OpenCode, is blocked on an implementation detail, wants cross-checking on a patch or command sequence, or needs a reusable OpenCode consultation archive for later threads.
---

# OpenCode For Codex

Use this skill to make OpenCode a traceable sidecar, not a mysterious oracle.

## When To Use

- Codex is blocked and wants a second opinion before changing code.
- Codex wants OpenCode to suggest commands, debugging steps, or patch directions.
- Codex wants an external cross-check on risk, edge cases, or tradeoffs.
- The result should be reusable by later threads, so the consultation must be archived.

Do not use this skill for routine work you can already finish locally.

## Boundaries

- Never claim to see OpenCode's internal reasoning.
- Only trust OpenCode CLI outputs, logs, exported files, and exit status.
- Keep Codex as the decision maker. OpenCode is advisory unless the user explicitly asks otherwise.

## Default Workflow

1. Confirm the workspace to consult on.
2. Write a focused prompt packet:
   - goal
   - current facts
   - blocker or question
   - requested output shape
   - constraints or files to inspect
3. Run:

```bash
bash /absolute/path/to/opencode-for-codex/scripts/run_opencode_consult.sh \
  --workspace "/absolute/workspace" \
  --prompt-file "/absolute/prompt.md"
```

If the executable is not on `PATH`, set `OPENCODE_BIN` first.

4. Read the archived result directory.
5. Record Codex's own decision in `codex-decision.md` using one of:
   - `adopt`
   - `reject`
   - `verify-separately`

## Prompt Packet Template

Keep prompts crisp and falsifiable:

```markdown
# Goal
One sentence on what OpenCode should help with.

# Known Facts
- Fact 1
- Fact 2

# Question
The exact blocker or review ask.

# Expected Output
- Recommended approach
- Key commands or files
- Risks or caveats

# Constraints
- Do not invent hidden context
- Use only visible files / CLI outputs
```

## Output Contract

By default the script writes to:

`<workspace>/docs/ai-handoff/opencode/<timestamp>-<slug>/`

Expected files:

- `prompt.md` - exact prompt sent to OpenCode
- `command.txt` - reproducible CLI command
- `command.json` - exact CLI argv for machine reuse
- `meta.json` - run metadata
- `raw.jsonl` - raw OpenCode JSON stream
- `stderr.log` - CLI stderr and debug trail
- `answer.md` - extracted plain-text answer when available
- `status.txt` - `success` or `failure`
- `codex-decision.md` - Codex decision note with `adopt`, `reject`, or `verify-separately`

## Failure Handling

If the run fails:

- keep `prompt.md`, `command.txt`, `stderr.log`, and `status.txt`
- summarize the failure in `codex-decision.md`
- prefer one retry only when the failure looks transient

Treat these as standard failure classes:

- `unknown certificate verification error`
- network reset / timeout
- rate limit / quota exhaustion
- upstream provider unavailable or model temporarily disabled
- empty response
- CLI missing or auth missing

## Certificate Error Rule

If `unknown certificate verification error` appears:

1. Check whether a fresh rerun succeeds.
2. Check whether direct HTTPS to `https://opencode.ai/zen/go/v1/chat/completions` works with `curl -I`.
3. Record whether the issue is persistent or intermittent.
4. Do not bypass TLS verification in the default workflow.

If the issue is intermittent, archive the failure and continue only after a successful rerun.
If the issue is persistent, stop and report the provider/runtime edge as the blocker.

## Provider Health Rule

If the error suggests upstream API health rather than local runtime trouble, say so explicitly.

Typical signals:

- HTTP 429
- quota exceeded
- rate limit exceeded
- provider unavailable
- model overloaded
- upstream 5xx

When those appear:

1. archive the raw failure
2. tell the user the OpenCode upstream API may be the problem
3. avoid mislabeling it as a local certificate or wrapper issue
4. retry only if the user wants a fresh check or the failure looks transient

## Notes For Later Threads

- Prefer `--format json` so the raw stream can be archived.
- Pass `--dir` with the real workspace so OpenCode sees the correct repository context.
- If you need a specific model, add `--model provider/model`.
- If the workspace already has a handoff convention, keep this archive append-only and local.
- Keep the repository path explicit in examples so the skill remains portable across machines.
