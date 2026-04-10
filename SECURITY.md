# Security Policy

## Reporting a Vulnerability

This project currently does not provide a private security reporting channel.

If you need to report a security problem, open a GitHub issue and include:

- a short description of the issue
- affected files or commands
- impact assessment if known
- reproduction steps or evidence

Prefix the title with `security:` and avoid pasting secrets, tokens, private prompts, or sensitive local workspace content.

## What Counts As Security-Relevant Here

Examples include:

- command injection risks
- unsafe handling of prompt or shell input
- accidental disclosure of local secrets in archives
- documentation that encourages insecure defaults

## Response Expectations

The project aims to:

- acknowledge receipt within 7 days
- assess severity and reproducibility
- coordinate a fix before public disclosure when possible

## Current Security Posture

This is a small shell-and-docs project. The biggest practical risks are unsafe shell usage, leaking sensitive workspace material into archives, and misleading operational guidance. Security fixes that reduce those risks are especially valuable.
