# Contributing

Thanks for considering a contribution.

## Before You Start

This repository is intentionally small. Most changes fall into one of these categories:

- improve the OpenCode consultation workflow
- tighten documentation or examples
- clarify failure handling or archive conventions
- improve portability or validation for the shell scripts

For larger behavior changes, please open an issue before spending time on a pull request. That helps keep the skill focused and avoids wasted work.

## Development Workflow

1. Fork the repository or create a topic branch.
2. Keep changes scoped. Small PRs are easier to review and safer to release.
3. Update docs when behavior, file layout, or user workflow changes.
4. Run the local verification commands before opening a PR.

## Local Verification

Run these commands from the repository root:

```bash
bash -n scripts/run_opencode_consult.sh
bash -n scripts/selfcheck.sh
bash scripts/selfcheck.sh
OPENCODE_BIN=/usr/bin/true bash scripts/selfcheck.sh
```

If your change affects a real OpenCode integration path, include manual verification notes in the PR description.

## Pull Request Expectations

Please include:

- a short explanation of the problem
- the exact change you made
- verification evidence
- any follow-up work that remains out of scope

If your PR changes output files or archive behavior, include before/after examples where possible.

## Scope Guidance

Good fits for this repository:

- better archive provenance
- safer shell behavior
- clearer installation and troubleshooting docs
- improved GitHub project hygiene

Usually out of scope unless discussed first:

- unrelated OpenCode wrappers
- large framework migrations
- opinionated automation that hides raw artifacts

## Code Style

- Prefer portable Bash and simple dependencies.
- Keep docs concise and operational.
- Avoid machine-specific paths in examples unless the user is expected to replace them.
- Preserve append-only archive behavior unless there is a strong reason to change it.

## Review Philosophy

This project favors explicitness over magic. A contribution is stronger when a future maintainer can understand the behavior quickly from the docs and stored artifacts.
