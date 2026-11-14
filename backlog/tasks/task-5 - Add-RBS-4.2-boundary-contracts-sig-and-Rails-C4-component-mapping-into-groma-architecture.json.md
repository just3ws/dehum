---
id: TASK-5
title: >-
  Add RBS 4.2 boundary contracts (sig/) and Rails C4 component mapping into
  groma/architecture.json
status: To Do
assignee: []
created_date: '2026-11-14T22:48:00Z'
labels:
  - typesafety
  - rbs
  - groma
dependencies: []
priority: medium
ordinal: 5000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Add sig/ RBS 4.2 signatures for external service boundaries and emit Rails controllers/models/jobs into groma/architecture.json.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 rbs -I sig validate passes
- [ ] #2 groma scan --plain passes with zero findings
<!-- AC:END -->
