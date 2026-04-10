# Future Skill Extraction: github-open-source-release

## Why This Should Become A Skill

This repository hardening work is reusable. The repeatable part is not the OpenCode integration itself, but the workflow for turning a personal project into a public GitHub repository with standard community-health files and release hygiene.

## Candidate Skill Name

`github-open-source-release`

## Intended Trigger Cases

Use when a user says things like:

- "Help me open source this repo"
- "Make this GitHub project publish-ready"
- "Set up standard community files"
- "Prepare my first public release"
- "I have never maintained an open source repo before"

## What The Skill Should Standardize

1. Inspect the repository first.
2. Classify the project type:
   - library
   - CLI tool
   - docs-first project
   - script or automation repository
   - skill or plugin repository
3. Choose the minimum healthy file set.
4. Draft:
   - README improvements
   - LICENSE selection guidance
   - CONTRIBUTING
   - CODE_OF_CONDUCT
   - SECURITY
   - SUPPORT
   - issue and PR templates
   - CHANGELOG and release guide
5. Verify local commands before any completion claim.
6. Flag placeholders that must be replaced before pushing.
7. Optionally assist with GitHub push and first release.

## What Should Stay Project-Specific

- license choice when there are business constraints
- maintainer contact details
- support channel preferences
- repository URL and issue-template contact links
- release version number and scope promises

## Suggested Bundled Resources

- `references/github-community-health-checklist.md`
- `references/release-writing-guide.md`
- `assets/` templates for issue and PR docs when standard wording is helpful

## Validation Rules For The Future Skill

- never claim the repo is publish-ready without fresh verification
- distinguish placeholders from final values
- avoid generic boilerplate when the repository scope is narrow
- prefer minimal standards that the maintainer can actually sustain
