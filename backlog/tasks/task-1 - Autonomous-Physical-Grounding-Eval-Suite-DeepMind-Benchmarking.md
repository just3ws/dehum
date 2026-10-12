---
id: TASK-1
title: Autonomous Physical-Grounding Eval Suite (DeepMind Benchmarking)
status: To Do
assignee: []
created_date: '2026-10-12 22:28'
labels:
  - evals
  - deepmind
  - physical-grounding
dependencies: []
priority: high
type: feature
ordinal: 1000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build an empirical benchmark harness that feeds raw EMI-corrupted media containers to frontier LLMs (Gemini, Claude, GPT) to evaluate whether they fall into the container duration 'atempo' clock-drift trap or correctly verify physical lip-sync articulation before modifying time bases.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 CLI harness runs against Gemini 3.8 Flash and Claude 3.7 Sonnet
- [ ] #2 Detects hallucinated atempo duration ratios vs apad trailing padding
- [ ] #3 Generates automated scoring report with Classic Loki rating
<!-- AC:END -->
