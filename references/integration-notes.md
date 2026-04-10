# OpenCode Integration Notes

## Goal

Make OpenCode callable from Codex in a way that is reproducible, inspectable, and easy to hand off across threads.

## Chosen Shape

- Skill lives in `~/.agents/skills/opencode-for-codex/`
- Source repository can live anywhere and be symlinked into the local skills directory
- Runtime wrapper lives in `scripts/run_opencode_consult.sh`
- Per-run artifacts live under the target workspace, defaulting to `docs/ai-handoff/opencode/`

## Why This Shape

- It mirrors the useful part of `openai/codex-plugin-cc`: a stable command surface plus a way to retrieve results later.
- It keeps the archive near the consulted repo instead of hiding it in a global cache.
- It treats OpenCode as a consultative worker with explicit provenance, not as an invisible background dependency.

## Current CLI Findings

- Binary: `/Users/hackdion/.opencode/bin/opencode`
- Observed working command:

```bash
/Users/hackdion/.opencode/bin/opencode run '只回复 OK' --format json --dir '/Users/hackdion/Documents/洛克每日资讯'
```

- Observed provider path in logs:

`https://opencode.ai/zen/go/v1/chat/completions`

## Certificate Error Assessment

Historical logs captured:

- `UNKNOWN_CERTIFICATE_VERIFICATION_ERROR`
- `ECONNRESET`

Fresh local retest on 2026-04-10 also succeeded, and direct `curl -I` to the same host completed the TLS handshake. That suggests the certificate issue is not a hard local trust-store failure. The more likely causes are:

1. intermittent provider-edge TLS issues
2. transient runtime/network resets during streaming requests
3. a provider/runtime-specific certificate chain handling bug

This should be distinguished from provider-side API failures such as:

- quota exhaustion
- model-specific rate limiting
- upstream provider outage
- temporary model disablement

Those are not wrapper bugs. When logs point there, Codex should tell the user the OpenCode upstream API is the likely issue.

## Operational Rule

- Do not disable certificate verification in the normal workflow.
- Retry once if the failure looks transient.
- Archive both failure and success so later threads can see the evidence trail.

## Open-Source Packaging Notes

- Repository examples should avoid machine-specific absolute paths except where the user is expected to replace them.
- The wrapper should prefer `OPENCODE_BIN`, then `PATH`, then a local default under `$HOME/.opencode/bin/opencode`.
- A minimal self-check script is enough for this repository as long as it validates dependencies and runner invocation.
