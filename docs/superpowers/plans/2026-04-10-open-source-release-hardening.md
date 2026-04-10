# Open Source Release Hardening Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Raise this repository from a personal working skill repo to a public GitHub project with clear contribution, support, security, and release standards.

**Architecture:** Treat the repository as a small shell-and-docs open source project. Keep the runtime surface minimal while adding GitHub community-health files, reusable templates, and release-process documentation around the existing skill and scripts.

**Tech Stack:** Markdown, Bash, GitHub Actions, GitHub community health files

---

### Task 1: Define repository standards and file map

**Files:**
- Create: `docs/superpowers/plans/2026-04-10-open-source-release-hardening.md`
- Create: `docs/release-notes/`
- Modify: `README.md`

- [ ] **Step 1: Record the release-hardening scope**

Add a plan that covers community files, templates, release docs, verification, and future skill extraction.

- [ ] **Step 2: Verify repository structure before adding docs**

Run: `find . -maxdepth 3 -type f | sort | rg -v '^\\./\\.git/'`
Expected: only the current project files appear, with no unexpected private artifacts.

- [ ] **Step 3: Commit planning artifacts after implementation batch**

```bash
git add docs/superpowers/plans
git commit -m "docs: add open source release hardening plan"
```

### Task 2: Add GitHub community health files

**Files:**
- Create: `CONTRIBUTING.md`
- Create: `CODE_OF_CONDUCT.md`
- Create: `SECURITY.md`
- Create: `SUPPORT.md`

- [ ] **Step 1: Write contribution policy**

Document contribution scope, local verification commands, issue-first rules, and review expectations.

- [ ] **Step 2: Add behavior expectations**

Adopt a concise contributor covenant based code of conduct with contact path.

- [ ] **Step 3: Add security reporting policy**

Define private reporting expectations, response targets, and what not to disclose publicly.

- [ ] **Step 4: Add support routing**

Explain where to ask usage questions, where to file bugs, and what information maintainers need.

- [ ] **Step 5: Verify docs are discoverable**

Run: `find . -maxdepth 2 -type f | sort | rg 'CONTRIBUTING|CODE_OF_CONDUCT|SECURITY|SUPPORT'`
Expected: all four files are present in the repository root.

### Task 3: Add issue and PR templates

**Files:**
- Create: `.github/ISSUE_TEMPLATE/bug_report.md`
- Create: `.github/ISSUE_TEMPLATE/feature_request.md`
- Create: `.github/ISSUE_TEMPLATE/config.yml`
- Create: `.github/PULL_REQUEST_TEMPLATE.md`

- [ ] **Step 1: Add bug report template**

Capture environment, command used, expected behavior, actual behavior, and archive evidence.

- [ ] **Step 2: Add feature request template**

Require problem statement, proposal, alternatives, and repository fit.

- [ ] **Step 3: Add issue template config**

Point support questions to `SUPPORT.md` and keep blank issues disabled unless explicitly needed.

- [ ] **Step 4: Add PR checklist**

Require self-check, docs updates, and note whether behavior or archive format changed.

- [ ] **Step 5: Verify template file layout**

Run: `find .github -maxdepth 3 -type f | sort`
Expected: CI workflow plus issue and PR templates are listed.

### Task 4: Add release and versioning guidance

**Files:**
- Create: `CHANGELOG.md`
- Create: `RELEASE.md`
- Create: `docs/release-notes/v0.1.0.md`
- Modify: `README.md`

- [ ] **Step 1: Define versioning policy**

Document that the repository starts from `v0.1.0` while interfaces may still evolve.

- [ ] **Step 2: Add changelog structure**

Use a Keep a Changelog style format with an initial unreleased section and first release section.

- [ ] **Step 3: Add release operator guide**

Explain branch cleanliness checks, verification commands, tag naming, and GitHub release note flow.

- [ ] **Step 4: Add first release note draft**

Summarize initial public scope, included files, and known limitations.

- [ ] **Step 5: Update README to point to release workflow**

Link the changelog, release process, and support documents from the main README.

### Task 5: Verify repository quality and prepare for future skill extraction

**Files:**
- Modify: `README.md`
- Modify: `docs/superpowers/plans/2026-04-10-open-source-release-hardening.md`

- [ ] **Step 1: Run repository verification**

Run: `bash -n scripts/run_opencode_consult.sh && bash -n scripts/selfcheck.sh && bash scripts/selfcheck.sh && OPENCODE_BIN=/usr/bin/true bash scripts/selfcheck.sh`
Expected: all commands exit successfully and self-check prints `Self-check passed.`

- [ ] **Step 2: Verify git working tree**

Run: `git status --short --branch`
Expected: either a clean branch or only the intended release-hardening files appear.

- [ ] **Step 3: Summarize reusable skill extraction candidates**

Capture which parts of this process can later become a standalone `github-open-source-release` skill without copying project-specific content.

- [ ] **Step 4: Commit the release-hardening batch**

```bash
git add .
git commit -m "docs: add open source community standards"
```
