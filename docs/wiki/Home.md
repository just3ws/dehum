# Project Wiki: Under the High-Tension Wires

> *"I come from a subculture of Chicago software craftspeople who believe code should be written cleanly, tested ruthlessly, and that when you find something wrong, you stop and make it right."*  
> — Mike Hall, *The Sound Above*

Welcome to the central knowledge repository for **`just3ws/dehum`**—an open forensic experiment exploring the boundary between automated generative artifice and physical ground truth.

---

## 🧭 Wiki Index & Field Navigation

- **[Architecture & Signal Flow](Architecture-and-Signal-Flow.md)**: The 5-stage mathematical DSP pipeline, notch bandwidth filters ($Q=30$), and lossless H.264 stream muxing.
- **[The Hallucination Anatomy](The-Hallucination-Anatomy.md)**: Deep forensic autopsy of the `atempo=0.837` linear clock drift trap and container duration discrepancies.
- **[The Sovereign Verification Protocol](The-Sovereign-Verification-Protocol.md)**: Defining the modern *Definition of Done* when code generation is nearly free ($39.40) but verification remains human ($10,000+).
- **[The Philosophy of Artifice (Classic Loki & Mjolnir)](The-Philosophy-of-Artifice.md)**: The cultural, philosophical, and meta-inquiry reflections on "Glorious Purpose", badges, air of legitimacy, and whether we are worthy to wield the hammer.
- **[Reproduction & Field Runbook](Reproduction-and-Field-Runbook.md)**: Step-by-step instructions for running the pipeline locally with Bash 3.2, ffmpeg, and bc.
- **[Sponsorship & Community Support](Sponsorship-and-Support.md)**: Support independent forensic acoustics, open inquiry, and software craftsmanship.

---

## ⚡ Quick Ground Truth Summary

| Attribute | Forensic Baseline |
| :--- | :--- |
| **Original Audio Fault** | High-voltage 60 Hz EMI hum + 120/180/240 Hz harmonics + corona micro-arcing |
| **Initial Agent Trap** | Slurred speech via `atempo=0.837` hallucinated from a container duration gap |
| **Physical Reality** | Zero crystal clock drift; speech cadence was 1:1; gap was pure trailing silence |
| **Final Resolution** | Sequential DSP (`highpass` -> `adeclick` -> `afftdn` -> `bandreject`) + `-c:v copy` |
| **Economic Ratio** | $39.40 inference compute vs. $10,010 sovereign verification labor (250:1) |
