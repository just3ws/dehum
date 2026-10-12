# Security Policy & Sensitive Data Boundaries

## Supported Versions

| Version / Branch | Supported |
| :--- | :--- |
| `main` | :white_check_mark: |

---

## Reporting Vulnerabilities or Information Disclosures

This repository enforces strict automated boundaries against unintentional information disclosure:
- **No Personal Identifiable Information (PII)**: Emails, phone numbers, GPS coordinates.
- **No Protected Health Information (PHI)**.
- **No Local Machine Paths**: Hardcoded home paths are blocked by pre-commit and pre-push hooks via `bin/audit_tmi.rb`.

If you identify a security vulnerability, an unintended disclosure of sensitive data, or a boundary breach:
1. Please **do not** open a public issue.
2. Report the disclosure via a private security advisory on GitHub or directly via the contact channels on [just3ws.com](https://www.just3ws.com).
3. We will review, scrub git history if necessary, and patch the automated audit regex within 24 hours.
