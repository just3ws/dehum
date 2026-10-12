# Audio/Video Dehum & Linear Sync Drift Restoration Context

## 1. Executive Summary & Incident History
This directory was created to resolve audio corruption in `VID_20261009_111445043.mp4`, a 21m 43s video recorded under high-voltage overhead power transmission lines.
The file suffered from two concurrent electromagnetic interference (EMI) failure modes:
1. Severe audio/video linear sync drift: The audio clock ran significantly faster than the video frame rate, resulting in audio finishing at 18m 11s (1091.09s) while video finished at 21m 43s (1303.61s) — an exact drift of 212.5 seconds.
2. Electromagnetic field coupling: Intense 60 Hz mains hum, 10 audible harmonic overtones (up to 600 Hz), broadband electrostatic induction hiss, and over 3.9 million microsecond corona discharge click/crackle impulses.

The problem was resolved cleanly using a 5-stage audio DSP pipeline and lossless stream copying (`-c:v copy`) via `./fix_video.sh`.

---

## 2. Physical & Technical Architecture

### 2.1 Electromagnetic Coupling Mechanisms
- **Mains Induction**: 60 Hz alternating current (AC) in overhead high-tension lines induces an oscillating magnetic field $\vec{B}$, coupling directly into camera microphone traces and pre-amplifier circuits via Faraday's Law of Induction:
  $$\mathcal{E} = -\frac{d\Phi_B}{dt}$$
- **Corona Discharge Arcing (Crackle)**: When high electric field gradients ionize surrounding air particles, localized micro-arcing occurs along transmission wire bundles. These discharges produce broadband non-stationary impulse clicks appearing randomly throughout the waveform.
- **Harmonics**: Saturated transformer iron cores and non-linear power electronics produce odd and even harmonics:
  $$f_k = k \times 60\text{ Hz}\quad (k \in \{1, 2, \dots, 10\})$$
  Harmonics from 300 Hz to 600 Hz are perceived as a harsh electrical "buzz" or "frying" noise.

### 2.2 Hardware Crystal Misalignment & Clock Drift
Modern mobile devices and cameras use separate quartz crystal oscillators for baseband system timing and audio codec sampling (or digital PLL dividers):
- Strong EMI fields can perturb capacitive loading or interrupt PLL synchronizers, causing the audio codec to sample at an effective rate higher or lower than nominal 48 kHz.
- In `VID_20261009_111445043.mp4`, the audio duration was $1091.093333\text{ s}$ while the video duration was $1303.608144\text{ s}$.
- The precise stretch ratio is:
  $$\text{Ratio} = \frac{D_{\text{audio}}}{D_{\text{video}}} = \frac{1091.093333}{1303.608144} \approx 0.836979$$
- Passing this factor to FFmpeg's `atempo=0.836979` filter slows the audio stream by exactly $16.3\%$ down to $1303.594\text{ s}$ ($\Delta t = 14\text{ ms}$, within 1 video frame).

---

## 3. Audio DSP Filtergraph Specification

FFmpeg filtergraph string:
```text
highpass=f=80,adeclick,afftdn=nr=10:nf=-45:tn=1,bandreject=f=60:width_type=q:w=30,bandreject=f=120:width_type=q:w=30,bandreject=f=180:width_type=q:w=30,bandreject=f=240:width_type=q:w=30,bandreject=f=300:width_type=q:w=30,bandreject=f=360:width_type=q:w=30,bandreject=f=420:width_type=q:w=30,bandreject=f=480:width_type=q:w=30,bandreject=f=540:width_type=q:w=30,bandreject=f=600:width_type=q:w=30,atempo=<ratio>
```

### Stage Details:
1. `highpass=f=80`: 2nd order Butterworth highpass filter. Eliminates sub-audible mechanical and handling rumble without affecting vocal formants.
2. `adeclick`: Autoregressive sample predictor. Crucial: Must precede `afftdn` and `atempo` so sharp impulse spikes do not smear into spectral bins or granular crossfade windows.
3. `afftdn=nr=10:nf=-45:tn=1`: FFT spectral subtractor with real-time noise tracking (`tn=1`) and $-45\text{ dB}$ noise floor. Suppresses broadband corona hiss.
4. `bandreject=f=<f>:width_type=q:w=30`: 10 narrow Butterworth notch filters ($Q=30 \implies \Delta f = f/30$). Total cut at center frequency, preserving speech intelligibility.
5. `atempo=<ratio>`: WSOLA (Waveform Similarity Overlap-Add) time-stretching engine. Stretches/shrinks duration with zero pitch change.

---

## 4. Operational Rules for Agents
1. **Never Re-encode Video Track**: Video stream must always pass through via `-c:v copy`.
2. **Bash 3.2 Compatibility**: macOS Golden Gate ships with Bash 3.2.57. Never use Bash 4+ parameter transformations (`${var,,}`); use `tr` or explicit pattern matches.
3. **Floating Point Precision**: Use `bc` with `scale=6`. Always check bounds $0.5 \le \text{ratio} \le 2.0$.
4. **ffprobe Wrapper Flags**: Always use `-of default=noprint_wrappers=1:nokey=1`. Do not use deprecated or misspelled options like `nocu=1`.
