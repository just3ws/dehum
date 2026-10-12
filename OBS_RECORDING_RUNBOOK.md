# Live Broadcast & Video Analysis Runbook: "Under the High-Tension Wires"
**Series**: *Ramblin' & Amblin' — Field Forensics* / *The Sound Above Errata*  
**Host**: Mike Hall (Staff Observability & Software Craftsmanship Architect)  
**Recording Date**: October 12, 2026  
**Artifact / Episode**: `errata-concept-under-the-high-tension-wires`  
**Target Video Master**: YouTube `8LYHo1dOkMo` / Local `/Users/mike/ai/dehum/VID_20261009_111445043_fixed.mp4`

---

## 1. Quick-Start Command Sequence (Terminal)

```bash
# 1. Validate OBS contracts, audio routing, and installed profiles
cd /Users/mike/github.com/just3ws/just3ws.github.io
bundle exec rake validate:obs
./obs/scripts/test-audio-routing.sh

# 2. Cue the live overlay state for this broadcast
bin/broadcast --errata --mode concept --title "Under the High-Tension Wires"

# 3. Launch OBS Studio
open -a OBS

# 4. Open iTerm2 with "The Sound Above" broadcast profile for live workbench demos
```

---

## 2. OBS Production Scenes & Visual Flow

| Scene # | Scene Name | Active Visual Elements | Audio Route | On-Screen Activity |
| :--- | :--- | :--- | :--- | :--- |
| **01** | `01. Starting Soon` | Dark Slate + Animated Pulse + Title HUD | Bumper / Silent | Pre-roll / Standby |
| **02** | `02. Monologue / Full Camera` | Full Host Camera + Minimal Lower Third | Host Mic (`RNNoise`) | Monologue thesis: The 250:1 leverage trap, the vague prompt, why "good enough" fails |
| **03** | `03. Reaction - Video Focus` | Chromium (80% canvas) + Host PiP + `Now Watching HUD` + Lower Third | Mic + Chromium Video Audio (`Track 3`) | Playing the YouTube video (`8LYHo1dOkMo`), scrubbing to key timestamps |
| **04** | `04. Split Screen - Video & Research` | Chromium (left) + `just3ws.localhost` (right) + Centered Host PiP | Mic + Chromium Video Audio | Correlating video playback directly against published article & transcript |
| **05** | `05. Workbench - Code & Terminal` | iTerm2 (full width) + Host PiP + Minimal Status Pill | Mic only | Terminal demos: `fix_video.sh --help`, `man fix_video`, `compare_transcripts.py` |
| **07** | `07. Intermission / BRB` | "Holding the Thread" card | Muted | Mid-broadcast pause / bio break |
| **08** | `08. Outro & Next Stream` | Outro Card + Archive Links + Next Ep Preview | Mic only | Closing reflections, sovereign verification challenge, wrap-up |

---

## 3. Teleprompter & Talking Points Script

### Segment 1: The Cold Open & Monologue (Scene 02: 00:00 – 04:00)
- **The Hook**: "Last Friday morning, I walked under 345,000-volt transmission towers with a Motorola phone in a crosswind. The microphone recorded a brutal 60 Hz hum, electrostatic corona discharge clicks, and wind flutter. The video recorded clean 1080p."
- **The Vague Prompt**: "I sat down at my machine and gave Gemini a simple, vague prompt: *'Fix the buzz and hum in this video, and fix the sync drift.'* Notice what I didn't give it: no DSP equations, no notch filters, no harmonic series, no spectral noise floor profiles. Just what 99% of people type into an LLM."
- **The Immediate Trap**: "The AI gave me a script back in 30 seconds. It looked authoritative. It used `ffmpeg`. And right there in the middle was: `atempo=0.837`. An arbitrary 16.3% audio slowdown that turned my voice into slow-motion sludge and destroyed the video."
- **The Core Question**: "Why did it do that? Because container timestamps and stream metadata had a 212-second mismatch, and the AI took the easiest syntactic shortcut. That is the 250:1 AI leverage trap."

### Segment 2: Video Reaction & Playback (Scene 03: 04:00 – 12:00)
*Cue YouTube (`https://youtu.be/8LYHo1dOkMo`) in Chromium window.*
- **00:00 – 00:11 (The Acoustic Baseline)**:
  - Play raw audio section.
  - *Host Note*: Point out the dual-microphone cancellation anomaly. In the raw audio, my voice pans hard right, but the wind roar stays centered.
- **00:11 – 01:30 (Speech Under High Tension)**:
  - Play restored speech ("Here I am...").
  - *Host Note*: Listen to the 5-stage filter chain. The 60 Hz hum is notched out with Q=30 bandreject filters; the corona clicks are scrubbed with `adeclick`.
- **04:00 – 04:20 (The Acoustic Ghost)**:
  - *Host Note*: Address the physical compromise. At 04:08, when the wind gust hits 25 mph, the adaptive spectral filter (`afftdn`) has to dig 22 dB into the noise floor. You can hear a slight metallic artifact. "An amateur hides that or runs an AI hallucination voice cloner. An engineer preserves the authentic physical acoustic record."

### Segment 3: Deep Research & Forensics Correlation (Scene 04: 12:00 – 20:00)
*Split screen: YouTube on left, `https://www.just3ws.localhost/ai/2026/10/12/under-the-high-tension-wires-building-deterministic-tools-from-nondeterministic-systems/` on right.*
- **The Economic Ledger**:
  - Show Section 4 of the article.
  - $39.40 of raw inference across 1,685 steps.
  - $10,010 of specialized human engineering labor across 5 disciplines (DSP acoustics, POSIX systems, static site infrastructure, editorial direction, sovereign verification).
  - The ratio: 250:1. "AI makes code generation free; it makes verification expensive."
- **The Forensic Transcript Diff**:
  - Show the Whisper telemetry comparison:
    - Raw Whisper: 1,938 words, WER 18.4%, 4 hallucinatory repetitions under heavy wind noise.
    - Restored Whisper: 2,045 words, WER 0.8%, 0 hallucinations, 107 recovered technical words.
  - "Cleaning the acoustic noise floor didn't just help human ears—it directly governed whether an downstream AI model hallucinated or understood reality."

### Segment 4: Live Workbench & Terminal Archaeology (Scene 05: 20:00 – 28:00)
*Switch to Scene 05: Workbench Terminal.*
- **1. Show the UNIX Tool**:
  ```bash
  /Users/mike/ai/dehum/fix_video.sh --help
  man /Users/mike/ai/dehum/fix_video.1
  ```
  - Emphasize: Strict POSIX compliance, Darwin BSD compatibility, automatic dependency checks (`ffmpeg`, `ffprobe`, `bc`), zero side effects, idempotent execution.
- **2. Show the Filter Graph**:
  ```bash
  # Stage 1: highpass=f=80
  # Stage 2: adeclick
  # Stage 3: afftdn=nr=18:nf=-45:tn=1
  # Stage 4: bandreject (60, 120, 180, 240, 300 Hz @ Q=30)
  # Stage 5: atempo (linear clock compensation only if delta > 50ms)
  ```
- **3. Show the Lossless Stream Copy**:
  - `-c:v copy -c:a aac -b:a 192k`
  - Zero generation loss on the 1080p camera frames. Not a single pixel was re-encoded.

### Segment 5: Outro & The Sovereign Verification Challenge (Scene 08: 28:00 – 32:00)
- **The "Skill Issue" Rebuttal**: "In contemporary tech discourse, when someone points out AI slop, people love to say *'skill issue'*. But true mastery isn't accepting an LLM's first smooth lie. True craftsmanship is testing the scaffolding and giving the raw source code to the public so they can audit it themselves."
- **The Links**: Point viewers to:
  - YouTube Master: `https://youtu.be/8LYHo1dOkMo`
  - Case Study: `https://www.just3ws.com`
  - LinkedIn Pulse: `https://www.linkedin.com/pulse/under-high-tension-wires-2501-ai-leverage-trap-slop-real-mike-hall-gbbtc`
  - GitHub Repo: `https://github.com/just3ws/dehum`

---

## 4. Master Reference Links & Local Endpoints

### Live Public Links
- **YouTube Master Video**: [https://youtu.be/8LYHo1dOkMo](https://youtu.be/8LYHo1dOkMo)
- **LinkedIn Published Pulse Article**: [https://www.linkedin.com/pulse/under-high-tension-wires-2501-ai-leverage-trap-slop-real-mike-hall-gbbtc](https://www.linkedin.com/pulse/under-high-tension-wires-2501-ai-leverage-trap-slop-real-mike-hall-gbbtc)
- **Published Case Study (Production)**: [https://www.just3ws.com/ai/2026/10/12/under-the-high-tension-wires-building-deterministic-tools-from-nondeterministic-systems/](https://www.just3ws.com/ai/2026/10/12/under-the-high-tension-wires-building-deterministic-tools-from-nondeterministic-systems/)
- **GitHub Tool Repository**: [https://github.com/just3ws/dehum](https://github.com/just3ws/dehum)

### Local High-Speed Endpoints & Files
- **Localhost Preview (Nginx 200 OK)**: `https://www.just3ws.localhost/ai/2026/10/12/under-the-high-tension-wires-building-deterministic-tools-from-nondeterministic-systems/`
- **Local Restored Video Master (1080p MP4)**: `/Users/mike/ai/dehum/VID_20261009_111445043_fixed.mp4`
- **Local Raw Corrupted Video (1080p MP4)**: `/Users/mike/ai/dehum/VID_20261009_111445043.mp4`
- **Full Forensic Report**: `/Users/mike/ai/dehum/FORENSICS.md`
- **Whisper Telemetry Diff**: `/Users/mike/ai/dehum/TRANSCRIPT_DIFF.md`
- **Economic & Technical Audit**: `/Users/mike/ai/dehum/ECONOMIC_AND_TECHNICAL_AUDIT.md`

---

## 5. Pre-Recording Pre-Flight Checklist

1. [ ] **Headphones / IEMs Connected**: Mandatory to prevent Chromium video audio from feeding back into host mic.
2. [ ] **Audio Meters Check**:
   - `Mic/Aux` bouncing cleanly between -12 dB and -6 dB.
   - `Video Application Audio (Chromium)` registers audio during YouTube test playback.
3. [ ] **Display Bindings**:
   - Scene 03/04: Verify `Video Window (Chromium)` is hooked to the active Chromium window.
   - Scene 04: Verify `Research Window` is hooked to the Safari/Chrome window displaying `just3ws.localhost`.
   - Scene 05: Verify `Workbench Terminal` is hooked to iTerm2.
4. [ ] **Overlay State**:
   - Verify Lower Third displays: *"Under the High-Tension Wires"* with subtitle *"250:1 AI Economic Leverage vs. The Mirage of Competence"*.
5. [ ] **Local Video Backup**: If internet bandwidth hiccups occur during stream, local `/Users/mike/ai/dehum/VID_20261009_111445043_fixed.mp4` is ready to play directly in QuickTime/IINA/VLC.
