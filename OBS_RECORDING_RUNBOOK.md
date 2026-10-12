# Live Broadcast & Video Analysis Runbook: "Under the High-Tension Wires"
**Series**: *Ramblin' & Amblin' — Field Forensics* / *The Sound Above Errata*  
**Host**: Mike Hall (Staff Observability & Software Craftsmanship Architect)  
**Recording Date**: October 12, 2026  
**Artifact / Episode**: `errata-concept-under-the-high-tension-wires`  
**Target Video Master**: YouTube `8LYHo1dOkMo` / Local `~/ai/dehum/VID_20261009_111445043_fixed.mp4`

---

## 1. Quick-Start Command Sequence (Terminal)

```bash
# 1. Validate OBS contracts, audio routing, and installed profiles
cd ~/github.com/just3ws/just3ws.github.io
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

### Segment 1: The Cold Open & Monologue (Scene 02: 00:00 – 05:00)
- **The Visual Contrast with Commercial AI Demos**:
  - "When people watch polished commercial AI demos from venture-backed tech labs, they see miracles. They see ten-second prompt videos orchestrated by dedicated motion designers and marketing teams, and they think the gap between a vague idea and reality has collapsed to zero."
  - "I want to show you what reality actually looks like when you face what is possible at this level for pocket change, compared to what the demo merchants sell."
- **The Physical Field Condition**:
  - "Last Friday morning, I walked under 345,000-volt transmission towers with a Motorola phone in a crosswind. The microphone recorded a brutal 60 Hz hum, electrostatic corona discharge clicks, and wind flutter. The video recorded clean 1080p."
- **The Vague Prompt & The Instant Trap**:
  - "I sat down at my machine and gave Gemini a simple, vague prompt: *'Fix the buzz and hum in this video, and fix the sync drift.'* Notice what I didn't give it: no DSP equations, no notch filters, no harmonic series, no spectral noise floor profiles. Just what 99% of people type into an LLM."
  - "Within 30 seconds, it handed me a confident, mathematically absurd hallucination: `atempo=0.837`. It took a container duration gap and slowed my voice by 16.3% into slurred slow-motion, completely wrecking the master."
- **Classic Loki, Glorious Purpose & The Artifice**:
  - "Over the last three days, as we worked through this, I watched this pairing system spin up an entire city of artifice around me. We willed POSIX man pages into existence, SVG vector diagrams, JSON-LD schemas, automated test harnesses, shields.io badges, and economic audit tables. For forty bucks."
  - "Standing in the middle of it, you feel like Classic Loki in the void, conjuring all of Asgard out of green light and shouting *'Glorious Purpose!'* It is breathtaking. It is an intoxicating distraction. But the monster—physical reality, the acoustic noise floor, the ground truth—is still coming. The artifice slowed the monster down, but it didn't change the laws of physics."
- **The Synchronicity with The Sound Above**:
  - "The deep irony and synchronicity is the topic of this entire show: *The Sound Above*. We're exploring the Chicago Software Craftsmanship movement—the engineers who gathered twenty years ago arguing over Kent Beck's four rules of simple design, deliberate practice, and knowing your tools down to the metal."
  - "This exercise is the living embodiment of that discipline in 2026. Without the craft—without demanding *'Prove it'*, without knowing phase distortion or room acoustics—that $39.40 of compute produces automated slop at scale. But *with* the craft, that $39.40 gives a solo engineer the forensic capability of an entire production studio and audio lab. That isn't a simulation. That's the work."

### Segment 2: Video Reaction & Playback (Scene 03: 05:00 – 12:00)
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
  - $39.40 of raw inference across 1,685 steps (actual out-of-pocket cash: ~$0.00–$2.00 across quota pools).
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
  ~/ai/dehum/fix_video.sh --help
  man ~/ai/dehum/fix_video.1
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
- **Mjolnir & The Air of Legitimacy**:
  - "Notice how easy it is today to manufacture the air of legitimacy: the shields.io badges, the JSON-LD schemas, the high-res social banners, the formatted man pages, the decimal-point telemetry. We have built an ecosystem where the symbols of authority are cheaper to generate than the rigor itself."
  - "It’s like someone walking up to Mjolnir and grabbing the handle. Today, anyone with a browser can grab the hammer of complex DSP, systems programming, or legal briefs. But the God of Thunder still asks: *Are you worthy?* Do you know what happens when the lightning actually arcs through the ground?"
- **The VC AI Buyout Pitch & "Should This Be in Rust?"**:
  - "People are already asking: *'Why isn't this rewritten in Rust? Or Mojo? How are you going to get that $50M seed valuation from Andreessen Horowitz with a 150-line Bash script? How are you going to buy the Bugatti?'*"
  - "Listen: my Bugatti is a gold 2013 Toyota Sienna with 180,000 miles, sliding electric doors, and stains from kids' juice boxes in the third row. It starts every single morning, it hauls lumber, it hauls people, and it doesn't need an over-the-air firmware subscription just to open the trunk."
  - "And that's what a 150-line Bash script is: it's the 2013 Toyota Sienna of audio engineering. It’s not flashy, it’s not going to win you a tech bro demo day in Miami, but while the AI hype merchants are stuck on the side of the road waiting for their GPU cluster to boot, the Sienna just keeps rolling down the highway at 65 miles an hour getting the work done."
  - "If I wanted a $50M seed round, I'd rebrand this tomorrow as **Dehum.ai: The Sovereign Autonomous Agentic Audio-Spatial Fabric™**. I'd wrap FFmpeg in a Docker container, deploy an un-quantized 70B parameter model to 'intelligently evaluate container drift', burn $40,000 of GPU compute a month to do what 3 lines of POSIX math does in 40 milliseconds, and slap a sleek Next.js glassmorphism dashboard on top."
- **The Core Warning: Building What We Cannot Verify**:
  - "I want to be completely, uncomfortably honest with you: **I cannot independently verify or validate many of the wild claims and figures being spun up by the AI in this repository.**"
  - "I am prompting it. It is generating numbers, economic ratios, decibel roll-offs, and claims about institutional value. And because it speaks with absolute, unwavering confidence, it is terrifyingly easy to nod along and accept the illusion."
  - "Let this be a warning to anyone using these tools: **Generative AI can make you spin up an entire mountain of infrastructure that is almost impossible to validate and verify independently.** We are entering an era where ordinary people and large corporations alike can will complex systems into existence that they do not understand—and then proceed to trust those systems with our data, our infrastructure, and potentially our lives."
  - "That is why this project isn't a victory lap. It's a distress beacon. If you cannot independently prove what the model is asserting down to physical ground truth, you haven't engineered anything—you've just surrendered your judgment to a hallucination."
- **And Yet: It IS Real**:
  - "**And yet... it is real.** That is the deepest paradox of this entire experience."
  - "The video is not a hallucination. The 345,000-volt power lines are real. The 60 Hz electromagnetic hum was real. The Motorola phone in the crosswind was real."
  - "And the output file sitting right here on my machine—`VID_20261009_111445043_fixed.mp4`—is real. You can hear my voice. You can watch my lips match every syllable. All 39,069 original camera frames survived bit-for-bit without losing a single pixel of resolution."
  - "The script is real. It runs in 40 milliseconds. It isn't a simulation of a tool; it is an actual tool that saved a corrupted master recording."
  - "That is the razor's edge we are walking: on one side, an ocean of unverified AI artifice and seductive hallucinations. On the other side, an actual, tangible piece of engineering that works in the physical world. The craft is learning how to stand right on that line without falling into either ditch."
- **Facing the Uncertainty ("Maybe this all sucks")**:
  - "Maybe this all sucks. Maybe it's nothing. I don't know. And honestly, that’s the best part. Because if you already think you know, you’re just a promoter buying your own press release. True craftsmanship is doing the work in the open, exposing the seams, and welcoming people to critique the compromises."
- **The Call to Audit**: Point viewers to:
  - YouTube Master: `https://youtu.be/8LYHo1dOkMo`
  - Case Study: `https://www.just3ws.com`
  - LinkedIn Pulse: `https://www.linkedin.com/pulse/under-high-tension-wires-2501-ai-leverage-trap-slop-real-mike-hall-gbbtc`
  - GitHub Repo: `https://github.com/just3ws/dehum` (Fully public: run the script on your own recordings)

---

## 4. Master Reference Links & Local Endpoints

### Live Public Links
- **YouTube Master Video**: [https://youtu.be/8LYHo1dOkMo](https://youtu.be/8LYHo1dOkMo)
- **LinkedIn Published Pulse Article**: [https://www.linkedin.com/pulse/under-high-tension-wires-2501-ai-leverage-trap-slop-real-mike-hall-gbbtc](https://www.linkedin.com/pulse/under-high-tension-wires-2501-ai-leverage-trap-slop-real-mike-hall-gbbtc)
- **Published Case Study (Production)**: [https://www.just3ws.com/ai/2026/10/12/under-the-high-tension-wires-building-deterministic-tools-from-nondeterministic-systems/](https://www.just3ws.com/ai/2026/10/12/under-the-high-tension-wires-building-deterministic-tools-from-nondeterministic-systems/)
- **GitHub Tool Repository**: [https://github.com/just3ws/dehum](https://github.com/just3ws/dehum)

### Local High-Speed Endpoints & Files
- **Localhost Preview (Nginx 200 OK)**: `https://www.just3ws.localhost/ai/2026/10/12/under-the-high-tension-wires-building-deterministic-tools-from-nondeterministic-systems/`
- **Local Restored Video Master (1080p MP4)**: `~/ai/dehum/VID_20261009_111445043_fixed.mp4`
- **Local Raw Corrupted Video (1080p MP4)**: `~/ai/dehum/VID_20261009_111445043.mp4`
- **Full Forensic Report**: `~/ai/dehum/FORENSICS.md`
- **Whisper Telemetry Diff**: `~/ai/dehum/TRANSCRIPT_DIFF.md`
- **Economic & Technical Audit**: `~/ai/dehum/ECONOMIC_AND_TECHNICAL_AUDIT.md`

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
5. [ ] **Local Video Backup**: If internet bandwidth hiccups occur during stream, local `~/ai/dehum/VID_20261009_111445043_fixed.mp4` is ready to play directly in QuickTime/IINA/VLC.
