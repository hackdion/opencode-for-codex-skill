# opencode-for-codex

Use OpenCode as a traceable second-opinion sidecar for Codex. This repository packages a reusable skill, a CLI wrapper, and a small archive convention so every consultation stays reproducible and inspectable.

## Highlights

- Portable shell wrapper with environment-variable override support
- Consultation archive saved beside the target workspace
- Preserves prompt, raw JSONL stream, stderr, and Codex follow-up decision
- Distinguishes local wrapper issues from upstream provider failures
- Lightweight self-check script plus GitHub Actions CI
- Includes standard GitHub community-health and contribution files

## Project Status

This project is ready for an initial public release and is best treated as early-stage but usable.

- Suggested first public release: `v0.1.0`
- Stability level: small, focused, still evolving
- Best suited for: maintainers who want explicit, inspectable OpenCode consultations from Codex

## Repository Layout

- `SKILL.md`: the skill instructions Codex follows when consulting OpenCode
- `scripts/run_opencode_consult.sh`: wrapper that runs OpenCode and archives the prompt, raw output, and a Codex decision note
- `scripts/selfcheck.sh`: dependency and smoke-check helper
- `references/integration-notes.md`: operational notes and known failure modes
- `agents/openai.yaml`: optional metadata for agent catalogs

## Why This Exists

The goal is not to let OpenCode silently make decisions. The goal is to:

- keep Codex as the decision maker
- archive every OpenCode consultation beside the target workspace
- preserve enough raw output to debug bad advice, flaky provider responses, or runtime issues later

## Requirements

- `bash`
- `jq`
- OpenCode CLI installed and authenticated

The runner resolves the OpenCode executable in this order:

1. `OPENCODE_BIN`
2. `opencode` from `PATH`
3. `$HOME/.opencode/bin/opencode`

## Install As A Local Skill

If you want Codex to load this repository as a local skill:

```bash
mkdir -p ~/.agents/skills
ln -s /absolute/path/to/opencode-for-codex ~/.agents/skills/opencode-for-codex
```

## Quick Start

1. Clone this repository somewhere stable, for example:

```bash
git clone <your-repo-url> ~/src/opencode-for-codex
```

2. Make the scripts executable:

```bash
chmod +x ~/src/opencode-for-codex/scripts/*.sh
```

3. Run the self-check:

```bash
bash ~/src/opencode-for-codex/scripts/selfcheck.sh
```

4. Run a consultation:

```bash
bash ~/src/opencode-for-codex/scripts/run_opencode_consult.sh \
  --workspace "/absolute/workspace" \
  --prompt-file "/absolute/prompt.md"
```

## Example Prompt

You can start from [`examples/prompt-template.md`](examples/prompt-template.md).

```markdown
# Goal
Get a second opinion on a blocker or risky patch direction.

# Known Facts
- Tests fail in one integration path
- Local logs point at timeout handling

# Question
What is the safest next debugging or patch direction?

# Expected Output
- Recommended approach
- Files or commands to inspect
- Risks or caveats

# Constraints
- Do not invent hidden context
- Use only visible files or CLI outputs
```

Prompt packets should stay crisp and falsifiable:

- goal
- known facts
- exact blocker or question
- expected output shape
- constraints on what OpenCode may inspect or assume

## Output Layout

Each run is archived under:

`<workspace>/docs/ai-handoff/opencode/<timestamp>-<slug>/`

Expected files:

- `prompt.md`
- `command.txt`
- `command.json`
- `meta.json`
- `raw.jsonl`
- `stderr.log`
- `answer.md`
- `status.txt`
- `codex-decision.md`

## Failure Model

The repository deliberately distinguishes:

- local wrapper or environment problems
- transient network or TLS issues
- upstream OpenCode provider failures such as `429`, quota exhaustion, model overload, or `5xx`

Do not disable TLS verification in the default workflow. Archive failures first, then decide whether a single retry is justified.

## Development

Run:

```bash
bash scripts/selfcheck.sh
```

For local syntax verification:

```bash
bash -n scripts/run_opencode_consult.sh
bash -n scripts/selfcheck.sh
```

This is a lightweight shell-based project, so the current validation path is shell syntax checking plus the runner self-check.

## Project Policies

- Contribution guide: [`CONTRIBUTING.md`](CONTRIBUTING.md)
- Code of conduct: [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md)
- Security policy: [`SECURITY.md`](SECURITY.md)
- Support policy: [`SUPPORT.md`](SUPPORT.md)
- Changelog: [`CHANGELOG.md`](CHANGELOG.md)
- Release process: [`RELEASE.md`](RELEASE.md)

## License

MIT. See [`LICENSE`](LICENSE).
