# Release Process

This repository is small enough to keep the release process simple, but explicit enough that future maintainers can repeat it safely.

## Versioning

- Start public releases at `v0.1.0`
- Use `v0.x.y` while interfaces and process details may still evolve
- Bump:
  - patch for fixes and documentation-only changes that do not alter behavior significantly
  - minor for new user-facing features or archive/output changes
  - major when compatibility promises are intentionally broken

## Pre-Release Checklist

1. Confirm the working tree is clean:

```bash
git status --short --branch
```

2. Run local verification:

```bash
bash -n scripts/run_opencode_consult.sh
bash -n scripts/selfcheck.sh
bash scripts/selfcheck.sh
OPENCODE_BIN=/usr/bin/true bash scripts/selfcheck.sh
```

3. Review `README.md`, `CHANGELOG.md`, and any changed examples.
4. Confirm no secrets, local archive outputs, or machine-specific notes were added.
5. Update `docs/release-notes/<version>.md`.

## Tagging A Release

After the release branch or `main` is ready:

```bash
git tag -a v0.1.0 -m "v0.1.0"
git push origin main --tags
```

## GitHub Release Notes

When creating the GitHub release:

- title: `v0.1.0`
- description source: `docs/release-notes/v0.1.0.md`
- include key usage guidance
- link to any migration or breaking-change notes when relevant

## After Release

- Move released items from `Unreleased` into the versioned section of `CHANGELOG.md`
- Start a fresh `Unreleased` section for the next cycle
- Verify issue templates and policy links still point to the correct default branch and repository URL
