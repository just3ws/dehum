# High-Voltage Audio Dehum, De-crackle & Sync Restoration Engine (`dehum`)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform: macOS / Linux](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-lightgrey.svg)](README.md)
[![FFmpeg: 7.x / 8.x / 9.x](https://img.shields.io/badge/FFmpeg-Ready-green.svg)](https://ffmpeg.org)

A high-fidelity forensic audio restoration pipeline and command-line utility for repairing video and audio recordings corrupted by **high-tension electromagnetic interference (EMI)**, **corona discharge micro-arcing**, and **asymmetric multi-mic mobile phone recording failures**.

---

## 1. Executive Summary & Forensic Narrative

### 1.1 The Initial Incident & Inquiry
A 21-minute 43-second video (`VID_20261009_111445043.mp4`, ~3.1 GB) was recorded on a mobile device (Motorola Moto G) directly beneath high-voltage overhead power transmission lines. 

Upon playback, the media presented severe issues:
1. **Intense Low-Frequency Buzz and Drone**: High-voltage 60 Hz electromagnetic induction accompanied by audible harmonic overtones spanning up to 600 Hz.
2. **Persistent Corona Discharge Crackle**: Non-stationary high-derivative impulse spikes throughout the recording, characteristic of atmospheric ionization and electrical discharge micro-arcing.
3. **Severe Stream Duration Discrepancy**: Container headers reported a video duration of **1303.61s** (21m 43s) but an audio duration of only **1091.09s** (18m 11s) — an apparent delta of **212.5 seconds (3.5 minutes)**.

The initial inquiry requested full restoration of speech intelligibility, removal of electrical hum and crackle, perfect audio/video synchronization, and **zero generational quality loss** on the video track.

---

### 1.2 Chronological Forensic Investigation

```
[Initial Inquiry]
       │
       ▼
[Hypothesis 1: Linear Clock Drift] ──► atempo=0.836979
       │                                     │
       │                                     ▼
       │                            [Result: Artificial Slurring & Severe Desync]
       ▼
[Whisper & Frame Diagnostics]
  • Speech onset ("Here I am...") at t=11.60s matches un-stretched audio exactly
  • Final words ("Thank you") delivered at t=1089s
  • Camera recorded trailing scenery silently for 3.5m after speech ended
  • Conclusion: Original speech was recorded at true 1.0x speed; duration gap was trailing silence
       │
       ▼
[Hypothesis 2: Spectral & Impulse Over-Filtering]
  • Default adeclick (t=2) destroyed vocal consonants (over-filtering)
  • Dynamic noise tracking (afftdn tn=1) caused underwater robotic flanging
  • Unbounded apad caused 176 hours of silence allocation & FFmpeg OOM
       │
       ▼
[Hypothesis 3: Asymmetric Hardware Channel Analysis (Root Cause)]
  • Motorola Moto G records stereo using primary (bottom) mic and secondary (top) mic
  • Channel Left (Primary):   SNR 14.0, Voice Dynamic Range 11.46 dB, Speech Intact
  • Channel Right (Secondary): SNR 1.05, Voice Dynamic Range 0.20 dB, Flooded by Induction
  • Low-frequency sub-rumble (<100 Hz) was 65.2x stronger in Right channel than Left!
  • Stereo playback had been playing pure induction noise from the top mic on top of clean voice
       │
       ▼
[Production Solution: Left Channel Isolation + Calibrated Multi-Stage DSP]
  • Isolated clean Left channel (pan=stereo|c0=c0|c1=c0)
  • Eliminated 98% of induction rumble before filtering
  • Restored natural 1.0x speech and bit-for-bit video copy
```

---

## 2. Technical Root Causes

### 2.1 Electromagnetic Coupling Mechanisms
1. **Faraday Induction ($\vec{B}$-Field)**:
   Alternating current (60 Hz AC) in high-voltage lines generates oscillating magnetic fields coupling into the device's printed circuit traces and pre-amplifiers:
   $$\mathcal{E} = -\frac{d\Phi_B}{dt} = -\frac{d}{dt} \int \vec{B} \cdot d\vec{A}$$
   Non-linearities in power equipment produce sharp odd and even harmonics ($60, 120, 180, 240, 300, \dots, 600\text{ Hz}$).
2. **Corona Discharge Arcing (Impulse Spikes)**:
   High electric field gradients ionize surrounding air, producing microsecond current pulses. In digital audio, these register as violent sample-to-sample amplitude jumps ($|\Delta s| > 2000$).
3. **Dual-Microphone Phone Asymmetry**:
   Smartphones utilize dual-microphone arrays for background noise cancellation. Under high-voltage transmission lines, the secondary top-mounted microphone acted as a high-gain inductive antenna, picking up pure electromagnetic drone while receiving minimal vocal energy. When mixed into stereo, this corrupts the entire soundstage.

### 2.2 Forensic Audio Metrics: Left vs. Right Channel
| Metric | Left Channel (Bottom Mic) | Right Channel (Top Mic) | Delta / Interpretation |
| :--- | :--- | :--- | :--- |
| **Silence RMS** | $176.31$ | $611.15$ | Right channel ambient noise is **$3.5\times$ louder** |
| **Speech RMS** | $659.78$ | $625.23$ | Right channel registers almost no acoustic gain |
| **Dynamic Range** | **$11.46\text{ dB}$** | **$0.20\text{ dB}$** | Right channel voice is buried beneath noise floor |
| **Signal-to-Noise Ratio (SNR)**| **$14.00$** | **$1.05$** | Right channel is mathematically unusable |
| **Sub-rumble Energy ($<100\text{ Hz}$)** | $7.86 \times 10^{15}$ | $5.12 \times 10^{17}$ | Right channel has **$65.2\times$ more low-frequency drone** |
| **Impulse Transients ($|\Delta s| > 2000$)** | $76$ | $4$ | Micro-arcing localized in Left microphone traces |

---

## 3. The Restoration Architecture

### 3.1 Lossless Video Stream Copy
Video frames are never decompressed or re-encoded:
```bash
-c:v copy
```
This guarantees zero compression artifacts, preserves native resolution, bitrate, color space, and completes processing in seconds rather than hours.

### 3.2 Multi-Stage Audio DSP Filtergraph
```
Input Audio ──► [Stage 0: pan] ──► [Stage 1: highpass] ──► [Stage 2: adeclick]
                     │                     │                      │
            Isolate Clean Left        Roll off <80Hz         Eliminate Arcing
            (pan=stereo|c0=c0|c1=c0)  Sub-Rumble Mud         Impulse Spikes
                     │                     │                      │
                     ▼                     ▼                      ▼
              [Stage 3: afftdn] ──► [Stage 4: bandreject] ──► [Stage 5: apad] ──► Output Audio
                     │                     │                      │
             Spectral Denoise      10x High-Q Notches       Pad Trailing Silence
             (nr=6:nf=-50)         (60Hz - 600Hz, Q=30)     (whole_dur=VIDEO_LEN)
```

1. **Stage 0 — Channel Selection (`pan=stereo|c0=c0|c1=c0`)**:
   Duplicates the speech-intact Left channel across both channels, instantly discarding the EMI-corrupted Right channel.
2. **Stage 1 — Sub-Audio Highpass (`highpass=f=80`)**:
   2nd order Butterworth highpass roll-off for mechanical wind and handling vibration.
3. **Stage 2 — Impulsive De-clicking (`adeclick=w=30:o=75:t=2:b=3`)**:
   Autoregressive sample predictor repairing micro-arcing click spikes before spectral processing.
4. **Stage 3 — FFT Spectral Denoising (`afftdn=nr=6:nf=-50`)**:
   Static spectral subtractor with a $-50\text{ dB}$ floor, avoiding dynamic tracking artifacts.
5. **Stage 4 — Harmonic Notch Filters (`bandreject=f=<f>:width_type=q:w=30`)**:
   Ten cascaded Butterworth notch filters targeting $60, 120, 180, 240, 300, 360, 420, 480, 540, 600\text{ Hz}$.
6. **Stage 5 — Container Duration Padding (`apad=whole_dur=${VIDEO_DURATION}`)**:
   Pads trailing silence to ensure exact container parity with the video stream without stretching audio.

---

## 4. Usage & Command-Line Reference

### 4.1 CLI Script: `fix_video.sh`
```bash
./fix_video.sh [OPTIONS] <input_file.mp4>
```

#### Key Options:
| Flag | Description | Default |
| :--- | :--- | :--- |
| `-h, --help` | Display comprehensive manual and usage instructions | — |
| `-n, --dry-run` | Analyze durations and output generated filtergraph without writing files | `false` |
| `-o, --output <path>` | Specify custom destination path | `<basename>_fixed.<ext>` |
| `--channel <left\|right\|stereo>` | Select audio channel isolation mapping | `left` |
| `--highpass <Hz>` | Cutoff frequency for sub-rumble highpass filter | `80` |
| `--q-factor <Q>` | Notch filter Q-factor (higher Q = narrower notch) | `30` |
| `--harmonics <N>` | Number of power line harmonic notches to apply | `10` |
| `--base-freq <Hz>` | Grid fundamental frequency (US: 60, EU: 50) | `60` |
| `--declick-thresh <T>` | Sensitivity threshold for `adeclick` filter | `2` |
| `--no-declick` | Disable impulse de-clicking stage | `false` |
| `--no-denoise` | Disable FFT spectral noise reduction | `false` |
| `--stretch` | Force linear time-stretching via `atempo` (for genuine clock drift) | `false` |

#### Examples:
```bash
# Standard automated restoration (clean Left channel, dehum, de-crackle):
./fix_video.sh VID_20261009_111445043.mp4

# Dry-run analysis:
./fix_video.sh --dry-run VID_20261009_111445043.mp4

# European 50 Hz power grid with stereo retention:
./fix_video.sh --base-freq 50 --channel stereo recording.mp4
```

### 4.2 System Manual Page
Inspect the full UNIX man page:
```bash
man ./fix_video.1
```

---

## 5. Integration with zdots & Transcription Pipeline

Once the audio stream is restored, run it through the local `zdots` transcription suite:

### 5.1 Extract 16 kHz Mono Audio for Whisper
```bash
ffmpeg -y -i VID_20261009_111445043_fixed.mp4 -vn -ar 16000 -ac 1 -c:a pcm_s16le audio_16k.wav
```

### 5.2 Execute `ztranscribe`
```bash
ztranscribe --from-wav audio_16k.wav --output-base transcript_clean
```
Outputs `.txt`, `.srt`, `.vtt`, `.json`, and `.summary.md`.

---

## 6. Repository Structure

```
dehum/
├── .gitignore                      # Ignore heavy binaries (*.mp4, *.wav) and scratch files
├── AGENTS.md                       # PVL Agent profile and subagent registration specification
├── CONTEXT.md                      # Physical and mathematical acoustics specification
├── PROMPT.md                       # Original task prompt and operational bounds
├── README.md                       # Complete engineering forensics and restoration guide
├── fix_video.sh                    # Production executable restoration tool (Bash 3.2 / macOS)
├── fix_video.1                     # Troff/groff UNIX man page
├── skills/
│   └── video-audio-dehum-sync/
│       └── SKILL.md                # Reusable Antigravity / Gemini CLI skill
└── sync_and_audio_delta.svg        # Forensic vector visualization of drift and spectrum delta
```

---

## 7. License & Credits
Developed under the **Panoramic View Labs (PVL)** initiative for high-fidelity audio/video forensics and media restoration.
Released under the MIT License.
