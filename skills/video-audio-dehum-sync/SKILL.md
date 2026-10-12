---
name: video-audio-dehum-sync
description: "Use to fix audio hum, buzzing, electrical crackle (corona discharge), and linear audio/video sync drift on video or audio recordings affected by electromagnetic interference (EMI) or clock crystal misalignment. Uses ffmpeg, ffprobe, and bc to run a lossless video copy with 5-stage audio DSP restoration."
---

# video-audio-dehum-sync

Automates multi-stage audio restoration and dynamic AV clock drift correction for video recordings affected by electromagnetic interference (EMI) — such as recordings made beneath high-voltage transmission lines or near industrial transformers — as well as hardware clock oscillator desynchronization.

## When to Use

Trigger this skill whenever:
- A user reports video recordings with electrical hum, buzzing, line frying, or corona arcing crackle.
- Audio and video drift out of sync linearly over time due to mismatched recording clock crystals.
- A user wants zero generational loss on video (copying video stream bit-for-bit with `-c:v copy`) while fixing audio tracks.
- Diagnosing or repairing files in `/Users/mike/ai/dehum/` or similar video paths.

## Tooling & Prerequisites

Required Homebrew utilities:
```bash
brew install ffmpeg ffprobe bc
```

The primary CLI script is located at:
```bash
./fix_video.sh
```

## Standard Execution Workflow

### 1. Probe & Analyze First (Dry Run)
Inspect the audio and video stream durations without modifying the file:
```bash
./fix_video.sh --dry-run /path/to/video.mp4
```
Check:
- `Video Duration` vs `Audio Duration`.
- Calculated speed ratio (e.g. `0.836979`).
- **CAUTION (The Clock-Drift Trap)**: Do NOT apply time-stretching (`atempo`) merely because audio duration differs from video duration. Check whether the audio stream simply ended early while the camera kept rolling, or whether trailing silence accounts for the gap. Verify lip-sync at speech onset before stretching audio.

### 2. Execute Restoration
Run standard restoration:
```bash
./fix_video.sh /path/to/video.mp4
```
This generates `/path/to/video_fixed.mp4` with:
- Video stream copied bit-for-bit (`-c:v copy`).
- Highpass roll-off at 80 Hz (`highpass=f=80`).
- Corona impulse de-clicking (`adeclick`).
- Adaptive FFT noise reduction (`afftdn=nr=10:nf=-45:tn=1`).
- 10 harmonic notch filters at 60 Hz increments (`bandreject`, Q=30).
- Dynamic time-stretching (`atempo=<ratio>`, only applied if delta > 50ms AND physical drift is confirmed).

### 3. Verify Output
Verify the output audio duration and perceptual integrity:
```bash
ffprobe -v error -show_streams /path/to/video_fixed.mp4 | grep -E "codec_name|duration="
```
Listen to the output. "Done" requires verifying that speech timing is unaltered, phase is intact, and intelligibility is restored without unnatural robotic artifacts.

## Parameter Customization & Edge Cases

| Condition | Recommended Command |
|---|---|
| European / UK 50 Hz Grid | `./fix_video.sh --base-freq 50 video.mp4` |
| Deep metallic buzz above 600 Hz | `./fix_video.sh --harmonics 16 video.mp4` |
| Low female voice or bass instruments attenuated | `./fix_video.sh --highpass 60 --q-factor 40 video.mp4` |
| Custom output path | `./fix_video.sh -o /target/path.mp4 video.mp4` |
| Only fix sync drift (no dehum/denoise) | `./fix_video.sh --no-declick --no-denoise --harmonics 0 video.mp4` |

## The 5 DSP Stages Reference

1. **`highpass=f=80`**: Attenuates sub-rumble and physical handling noise below speech range.
2. **`adeclick`**: Autoregressive interpolation of microsecond corona electrostatic arcing impulses.
3. **`afftdn=nr=10:nf=-45:tn=1`**: Adaptive FFT spectral denoiser with real-time tracking to lower the broadband induction floor.
4. **`bandreject=f=<f>:width_type=q:w=30`**: Razor-sharp notch filters (Q=30) covering fundamental and harmonics 1 through 10.
5. **`atempo=<ratio>`**: Non-pitch-altering time-stretch using WSOLA to align audio duration with video duration down to frame accuracy.
