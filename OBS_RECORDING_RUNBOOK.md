# Live Broadcast & Video Analysis Runbook: "Under the High-Tension Wires"
**Series**: *Ramblin' & Amblin' : Field Forensics* / *The Sound Above Errata*  
**Host**: Mike Hall (Staff Observability & Software Craftsmanship Architect)  
**Recording Date**: October 13, 2026  
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
- **The Real Origin: One Vague Google Search to PROMPT.md**:
  - "I didn't know anything about dual MEMS microphone arrays. I didn't know anything about ISO 14496-12 QuickTime atoms. I had a corrupted video and exactly one shred of human awareness: *I walked under high voltage wires.*"
  - "So I opened Google Chrome and typed: `recording a video under high tension wires repair audio sync`. That's it. That's the entire starting seed (saved in `archive/google_search_research/`)."
  - "Google's Gemini search overview generated what looked like an immaculate engineering spec, which I saved as `PROMPT.md`. But look at what the AI hallucinated right there in lines 11–15: it claimed high-tension wires *wander the phone's internal clock crystal*, measured the container gap, and told me to stretch my voice with `atempo=0.837`!"
  - "Within 30 seconds of running it, my voice was dragged into a slurred slow-motion parody. It was complete garbage. And it was my human ears that said: *'Wait, this is wrong.'*"
- **The Hitchhiker's Paradox: Deep Thought Answered 42 (What Was the Question?)**:
  - "It's like Deep Thought in The Hitchhiker's Guide to the Galaxy. The supercomputer calculated for seven and a half million years and proudly answered: *'42'*. And everyone stared blankly because nobody knew what the question was! With generative AI, we are living inside that exact punchline: we got an answer to a question we don't even know how to comprehend, much less ask."
  - "We typed a 13-word search under power lines: *'recording a video under high tension wires repair audio sync'*. The machine answered *'42'* (an atempo time-stretch of 0.837, ten cascading Butterworth notch filters, pole placements). It answered with supreme mathematical certainty, but nobody in physical reality asked that question. We didn't have clock drift; we had an unmuted secondary microphone acting as an antenna."
- **The Dual-Microphone Breakthrough ("From Weird to Here to Weird")**:
  - "I didn't prompt it about the phone's hardware. The AI only figured out the dual microphones when we split the stereo channels down to the metal: the top microphone trace was acting like a giant unshielded copper antenna pointing straight into the 345 kV lines, and the phone's own noise-cancellation circuit was blasting the hum right into the voice channel!"
  - "Look at the weirdness curve: we went from this weird acoustic buzz under power lines, to the AI hallucinating clock crystals and slow-motion drift, to digging through raw hardware traces to find the real physical antenna, and then spiraling into this other weirdness: 64-credit university syllabi, 10-panel dashboards, and Nietzsche's Zarathustra."
- **Classic Loki, Glorious Purpose & The Artifice**:
  - "Over the last three days, as we worked through this, I watched this pairing system spin up an entire city of artifice around me. We willed POSIX man pages into existence, SVG vector diagrams, JSON-LD schemas, automated test harnesses, shields.io badges, and economic audit tables. For pocket change."
  - "Standing in the middle of it, you feel like Classic Loki in the void, conjuring all of Asgard out of green light and shouting *'Glorious Purpose!'* It is breathtaking. It is an intoxicating distraction. But the monster (physical reality, the acoustic noise floor, the ground truth) is still coming. The artifice slowed the monster down, but it didn't change the laws of physics."
- **The Synchronicity with The Sound Above**:
  - "The deep irony and synchronicity is the topic of this entire show: *The Sound Above*. We're exploring the Chicago Software Craftsmanship movement: the engineers who gathered twenty years ago arguing over Kent Beck's four rules of simple design, deliberate practice, and knowing your tools down to the metal."
  - "This exercise is the living embodiment of that discipline in 2026. Without the discipline (without demanding *'Prove it'*, without knowing phase distortion or room acoustics), automated code generation produces slop at scale. But when grounded in verification, a solo engineer can achieve what used to take an entire production studio and audio lab. That is the real work."

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
  - $10.63 list API value across 3,695 steps and 501M tokens (actual out-of-pocket cash: under $1.25 on a $5/month promotional plan).
  - $10,010 of specialized human engineering labor across 5 disciplines (DSP acoustics, POSIX systems, static site infrastructure, editorial direction, sovereign verification).
  - The ratio: 1,000:1 to 8,000:1 leverage. "AI makes code generation free; it makes verification expensive."
- **The Forensic Transcript Diff**:
  - Show the Whisper telemetry comparison:
    - Raw Whisper: 1,938 words, WER 18.4%, 4 hallucinatory repetitions under heavy wind noise.
    - Restored Whisper: 2,045 words, WER 0.8%, 0 hallucinations, 107 recovered technical words.
  - "Cleaning the acoustic noise floor didn't just help human ears: it directly governed whether an downstream AI model hallucinated or understood reality."

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
  - "People are already asking: *'Why isn't this rewritten in Rust? Or Mojo? How are you going to get that $50M seed valuation with a 150-line Bash script?'*"
  - "And the answer is: because FFmpeg's filters are already hand-tuned C and SIMD assembly. Rewriting standard POSIX tools in Rust purely for status is the essence of green-light artifice."
  - "If I wanted a $50M seed round, I'd rebrand this tomorrow as **Dehum™ (not a real domain, do not buy this .ai domain): The Sovereign Autonomous Agentic Audio-Spatial Fabric™**. I'd wrap FFmpeg in a Docker container, deploy an un-quantized 70B parameter model to 'intelligently evaluate container drift', burn $40,000 of GPU compute a month to do what 3 lines of POSIX math does in 40 milliseconds, and slap a sleek Next.js glassmorphism dashboard on top."
- **The Corpus Fixation Trap & Semantic Stickiness**:
  - "And notice how dangerous prompt drift is: a side-comment casually typed in a conversation (even one you explicitly told the model to ignore) can get introduced into the corpus and become permanently stuck. The LLM fixates on it, weaves it into subsequent turns, and elevates a throwaway remark into a central architectural theme."
  - "Every word, every character, and the sequence they are keyed in matters. But we don't know which associative fragments will prove stickiest and hardest to purge. That semantic stickiness is the ultimate warning sign of synthetic systems."
- **"Over-Engineering is the New Hotness"**:
  - "Because in 2026, **over-engineering is the new hotness**. We used to mock over-engineering: the Rube Goldberg machines, the XML enterprise beans, the needless microservice sprawl."
  - "Now? An LLM makes over-engineering literally zero-marginal-cost. You can prompt a model and say *'Give me an enterprise solution'* and it will instantly give you Kubernetes manifests, Terraform state, OpenTelemetry collectors, and vector databases for a problem that required a notch filter."
  - "It’s over-engineering on tap. It feels productive, it looks impressive in a slide deck, and it generates thousands of lines of code you don’t understand. But true craftsmanship has always been the opposite: simple design, minimum moving parts, and knowing when to put the hammer down."
- **The Homer Simpson Car ("Wait! Don't go! Just... trust me bro!")**:
  - "Look at what happened here. If you're watching this, you're probably thinking: *'Wait. You wrote a 150-line Bash script to fix a YouTube video. Why do you have a 10-panel scientific dashboard, an accredited 64-credit university syllabus, and Walter Kaufmann's footnotes on Nietzsche?'*"
  - "And to that, I hold up two hands and say: *'Wait! Don't go! Just... trust me bro! You don't understand: the eagle represents microsecond transients! Look at the Q-factor on the third horn!'*"
  - "This is **The Homer**. In *The Simpsons*, Herb Powell gave Homer unconstrained authority to build a car with no friction and no budget constraints. Homer didn't stop at cup holders: he added giant bubble domes, three horns that play *La Cucaracha*, and giant tailfins. What did Homer forget to design into his car? *He forgot to design a car that anyone actually needed to drive.*"
  - "Generative AI is The Homer on an infinite credit card. The 150-line shell script is the minimal tool that actually hauls groceries. The rest of this repository is The Homer: glorious, magnificent, absurd, and held together by an engineer screaming *'Trust me bro!'* into a microphone."
- **The Zarathustra Inversion: The Mountain Before the Downgoing**:
  - "People love to quote Nietzsche's Zarathustra coming down from his mountain to preach in the marketplace. They fixate on the *downgoing* (*Untergang*). But they skip the opening sentence: *before you can descend, you have to spend ten years constructing the mountain*."
  - "In the marketplace, nobody understands. But Zarathustra survived the heights because of his two companions: **the eagle and the snake**. The eagle is panoramic vision, systems thinking, soaring elevation. The snake is the cleverest animal under the sun because its entire belly touches the cold dirt, feeling the vibration of the earth."
  - "An LLM lets anyone in the valley rent the eagle for 40 seconds. You feel like you're soaring at 10,000 feet. But you don't have the snake. You haven't spent 15 years crawling through broken container atoms and grounding loops. So when the synthetic eagle tells you to slow down your audio by 16%, you don't have the snake on your neck to whisper: *'Look at the ground. The lips on the screen are moving at 1.0x natural speed.'*"
- **The Core Warning: Building What We Cannot Verify**:
  - "I want to be completely, uncomfortably honest with you: **I cannot independently verify or validate many of the wild claims and figures being spun up by the AI in this repository.**"
  - "I am prompting it. It is generating numbers, economic ratios, decibel roll-offs, and claims about institutional value. And because it speaks with absolute, unwavering confidence, it is terrifyingly easy to nod along and accept the illusion."
  - "Let this be a warning to anyone using these tools: **Generative AI can make you spin up an entire mountain of infrastructure that is almost impossible to validate and verify independently.** We are entering an era where ordinary people and large corporations alike can will complex systems into existence that they do not understand, and then proceed to trust those systems with our data, our infrastructure, and potentially our lives."
  - "That is why this project isn't a victory lap. It's a distress beacon. If you cannot independently prove what the model is asserting down to physical ground truth, you haven't engineered anything; you've just surrendered your judgment to a hallucination."
- **And Yet: It IS Real**:
  - "**And yet... it is real.** That is the deepest paradox of this entire experience."
  - "The video is not a hallucination. The 345,000-volt power lines are real. The 60 Hz electromagnetic hum was real. The Motorola phone in the crosswind was real."
  - "And the output file sitting right here on my machine (`VID_20261009_111445043_fixed.mp4`) is real. You can hear my voice. You can watch my lips match every syllable. All 39,069 original camera frames survived bit-for-bit without losing a single pixel of resolution."
  - "The script is real. It runs in 40 milliseconds. It isn't a simulation of a tool; it is an actual tool that saved a corrupted master recording."
  - "That is the razor's edge we are walking: on one side, an ocean of unverified AI artifice and seductive hallucinations. On the other side, an actual, tangible piece of engineering that works in the physical world. The craft is learning how to stand right on that line without falling into either ditch."
- **The Legacy Test Dilemma & The Comforting Lies of Passing Specs**:
  - "I've worked in legacy codebases maintained over decades by dozens or hundreds of developers. We run test suites to reassure ourselves that code 'works.' But what does that test prove? It proves only that the system matches an isolated assertion written years ago, not whether it is doing what it *should*, or whether anyone alive still comprehends the trajectory of the architecture. We ship slop daily under the comforting umbrella of passing CI."
- **Straight to Legacy vs. AI Slop: What's the Difference?**:
  - "What's the difference between straight to legacy and AI slop? **Nothing. Nobody really understood what went in there either way.**"
  - "'Straight to legacy' was written by a human developer completing a Jira ticket in isolation, satisfying an isolated unit test, and merged as opaque legacy debt. 'AI slop' is the exact same phenomenon generated in 10 seconds by an LLM, adorned with zero-cost badges and diagrams, and merged without personal accountability. The only difference is speed, scale, and the elimination of responsibility."
- **The Strawberry Paradox & The Onus of Blame**:
  - "Now take that dilemma and scale it with AI. We are living in an absurd reality: **an LLM cannot reliably count the 'R's in the word 'Strawberry,' yet it can construct and reason through a 10-harmonic notch filter DSP pipeline.**"
  - "When millions of developers push uncomprehended AI code into production, where does accountability land? On the engineer prompting the machine? Or is blame pushed up the org chart into institutional plausible deniability? Comprehension is prohibitively costly in time and capital. That is why **Caveat Emptor** is our operating premise: this is an experiment, not an industry standard. Sovereign verification is the only defense."
- **The Arcade, The Tokens & Committing to the Bit**:
  - "Think about the article I wrote in April, *The Sound of Tokens*. In the 80s, you mowed lawns, fed brass tokens into the slot, and walked away proud of a sticker and a piece of bubble gum, while the arcade owner's kid rode by on a brand-new top-tier bike."
  - "Now look at what happened here. Over the last 48 hours, I spent pocket change feeding the token slot. I went from *'help fix this 21-minute video'* to *'what will it take to pivot this into a first round funding?'*"
  - "And then the chill hits: *'Wait... was the video even fixed to begin with?'* We were ready to pitch Sand Hill Road on a $50M Sovereign Agentic Spatial Fabric, and we hadn't even checked if the vocal sibilance was muffled!"
  - "That is the definition of **committing to the bit**. In comedy, you commit to the premise until it becomes absurd. In modern AI engineering, the model happily commits to the bit with you, building tailfins and bubble domes until you're completely lost in the forest of distraction."
  - "True Chicago Software Craftsmanship is knowing how to enjoy the bit, laugh at the absurdity, take the sticker and the gum, and ride your own bike home."
- **The Tech Bro AI Crypto-Capitalist Insight: Proof of Physical Work (PoPW)**:
  - "Here's the pitch when the tech bro AI cryptocapitalist in an interview asks what makes this cool: *'Look at the macro tokenomics.'* In modern AI, models act like zero-interest-rate central banks minting infinite synthetic token inflation with zero marginal cost. Most engineers take that inflation and debase their systems with 44.3% compounding fragility."
  - "*'Dehum'* is the ultimate deflationary asset: **Proof of Physical Work (PoPW)** on bare metal. We took synthetic compute and crystallized it into a zero-runtime-cost, local-first utility that executes in 14.8 seconds on bare CPU. While venture-backed wrappers burn $40,000 a month in GPU rent-seeking to run lossy cloud transcoding, we captured 1,000:1 leverage without handing a dime to the cloud cartel."
- **The Devaluation of Old Signals**:
  - "And don't be fooled by the outer polish. Man pages, Mermaid diagrams, clean markdown, and passing CI used to prove months of human dedication. Today, an AI can generate those symbols of authority in 10 minutes. Relying on those old signals is a dangerous bet. If you can't verify physical ground truth, it's just green light."
- **The Hallucination Series (By Mike Hall)**:
  - "And don't lose the headline: I didn't write the Bash script. That was generated. I didn't design the 10 harmonic notch filters. That was extruded. This entire exploration is organized under the theme **Hallucinations** (a play on my own name, Mike Hall, and the defining condition of our industry right now). These articles and tools are experiments in public learning: exploring what happens when human discernment collides with machine hallucinations."
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

## 5. Pre-Recording Curtain Call Checklist

### T-10 Minutes: Systems & Hardware Lights Check
1. [ ] **Headphones / IEMs Connected**: Mandatory to prevent Chromium video audio from feeding back into the host mic.
2. [ ] **Camera Framing & Exposure**: Confirm 1080p camera feed in Scene 02 (`Monologue / Full Camera`). Ensure eye level and head room are calibrated.
3. [ ] **Audio Meters & Filter Verification**:
   - `Mic/Aux` (Track 1) bounces cleanly in green/yellow between -12 dB and -6 dB with RNNoise suppression active.
   - `macOS Desktop Audio` (Track 2) captures system output cleanly via native CoreAudio.
   - `Video Application Audio (Chromium)` (Track 3) registers activity on YouTube playback test.
   - `Music / Soundboard` (Track 4) standby.
4. [ ] **Local Endpoints Live**:
   - Presentation Cockpit: `https://www.just3ws.localhost/dehum/dashboard.html` (HTTP 200 OK verified).
   - Case Study Article: `https://www.just3ws.localhost/ai/2026/10/12/under-the-high-tension-wires-building-deterministic-tools-from-nondeterministic-systems/`.

### T-5 Minutes: Window Geometry & Window Captures
1. [ ] **Chromium Recording Window**: Sized to 1920x1080 canvas, assigned to desktop space, loaded with `https://youtu.be/8LYHo1dOkMo`.
2. [ ] **iTerm2 Terminal Window**: Assigned profile `The Sound Above`, full width, cued to `~/ai/dehum/`.
3. [ ] **OBS Window Bindings Verified**:
   - Scene 03 / 04: `Video Window (Chromium)` locked to Chromium.
   - Scene 04: `Research Window` locked to browser showing `just3ws.localhost`.
   - Scene 05: `Workbench Terminal` locked to iTerm2.
4. [ ] **Overlay State Verified**:
   - Lower Third displays: *"The Mirage of Competence"* with subtitle *"An Experiment in Public on AI Slop and Domain Boundaries"*.
   - Auto-hide timer confirmed (auto-hides after 10 seconds).

### T-2 Minutes: Final Broadcast Standby
1. [ ] **YouTube Live Broadcast**: Confirm `https://studio.youtube.com/video/XS7EZ1eWH4U/edit` is set to "Upcoming" with calibrated metadata.
2. [ ] **Local Video Fallback**: `~/ai/dehum/VID_20261009_111445043_fixed.mp4` ready in QuickTime/VLC in case of internet streaming hiccups.
3. [ ] **Select Starting Scene**: Set active scene to `01. Starting Soon`.

### T-0: Curtain Call
1. Click **Start Recording** (and **Start Streaming** if going live).
2. Let bumper run on Scene 01 for 30 to 60 seconds.
3. Transition to Scene 02 (`Monologue / Full Camera`). Deliver the cold open: *The 13-word search, Deep Thought's 42, and the Mirage of Competence*.
4. Transition to Scene 03 to play the raw field recording (`8LYHo1dOkMo`) and demonstrate the 60 Hz hum vs bottom microphone fix.
5. Transition to Scene 04 for research correlation, and Scene 05 for CLI tool demos (`fix_video.sh --help`, `man fix_video`).
6. Transition to Scene 08 for the Outro and wrap-up.
7. Click **Stop Recording**.

