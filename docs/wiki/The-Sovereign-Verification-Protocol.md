---
title: "The Sovereign Verification Protocol"
description: "Forensic analysis and open knowledge documentation for just3ws/dehum"
license: "CC-BY-SA-4.0"
open_knowledge_foundation: "Open Definition 2.1 Conforming"
maintainer: "Mike Hall"
project: "just3ws/dehum"
date: "2026-10-12"
---

# The Sovereign Verification Protocol

> *"Code generation is free. Verification is everything."*

## The Economic Ledger: Synthetic Inflation vs. Sovereign Ground Truth

### 1. The Measured Token Ledger
Rather than hypothetical estimates, the exact physical SQLite conversation logs across the investigation (`~/.gemini/antigravity-cli/conversations/`) record:
- **Total Agent Execution Steps**: 3,695 steps
- **Uncached Input Tokens**: 16,862,403
- **Context Cache Read Tokens**: 483,199,583
- **Generated Output Tokens**: 1,034,112
- **Combined Tokens Processed**: **501,096,098 (0.501 Billion tokens)**

### 2. The Pricing & Billing Reality
- **Commercial API List Equivalent**: At standard Gemini developer API rates ($0.075/M uncached input, $0.01875/M cached input, $0.30/M output), this volume evaluates to **~$10.63** in raw API list value. (On un-cached commercial frontier APIs like Claude 3.5 Sonnet, 16.8M input + 1.0M output would have billed at ~$65.50).
- **Actual Out-of-Pocket Cash Spend**: The maintainer operates on the Google Gemini Pro ($20/month base) subscription under an active **$5/month promotional rate**. The marginal out-of-pocket cash spend for this entire project was between **$0.00 and $1.25** (the weekly amortized slice of a $5/month promotional plan), only needing to bridge to a free tier account once when weekly limits throttled.

Meanwhile, specialized human engineering forensic labor was valued at **$10,010**:
- **Acoustic & DSP Engineering**: $3,000 (Harmonic analysis, notch Q selection, phase distortion audit)
- **POSIX Systems & CLI Architecture**: $2,000 (Bash 3.2 compatibility, groff man page, zero external runtime deps)
- **Static Site & Infrastructure Architecture**: $2,000 (Jekyll automation, RSpec suites, A11y WCAG AAA audit)
- **Forensic Editorial & Epistemological Direction**: $2,000 (Translating telemetry into a coherent narrative of craft)
- **Physical Verification & Ground-Truth Auditing**: $1,010 (Whisper transcript diffs, frame-by-frame lip-sync verification)

The resulting leverage ratio ranges from **~1,000:1** (against raw developer API list cost) to over **2,000:1 - 8,000:1** (against actual amortized out-of-pocket subscription spend). The commonly cited **250:1** figure serves as a conservative floor assuming commercial unbundled compute.

---

## The 4 Steps of Sovereign Verification

To prevent AI code generation from collapsing into automated slop, every change must pass through the **Sovereign Verification Protocol**:

1. **Physical Grounding First**:
   - Probe container durations, but compare against real-world video frames.
   - Never accept an algorithm that sounds wrong to human ears, no matter how elegant the math looks.

2. **Zero Loss Muxing**:
   - Never re-encode uncorrupted streams. If only audio is broken, copy video bit-for-bit (`-c:v copy`).

3. **Automated Boundary Guards**:
   - Run strict TMI/PII scanners (`bin/audit_tmi.rb`) on every commit and push to prevent credential leaks, machine-name disclosures, or personal phone/email leaks.

4. **Emptying the Cup (*Shoshin*)**:
   - When the script exits with code 0, you are not done. You are only done when the master recording has been watched, listened to on headphones, and subjected to public scrutiny.
