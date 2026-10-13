---
name: dehum-audio-restoration
description: Forensic audio restoration, electromagnetic interference (EMI) cleanup, and AV clock-drift verification using the deterministic 5-stage DSP pipeline in ~/ai/dehum.
---

# Dehum Audio Restoration Skill

Use this skill when diagnosing or repairing corrupted audio/video recordings suffering from:
1. High-voltage electromagnetic interference (60 Hz fundamental + harmonics).
2. Corona discharge micro-arcing clicks and electrostatic buzz.
3. Mobile dual-microphone phase cancellation or asymmetry.
4. Apparent container duration discrepancies and linear clock-drift traps.

## Core Capabilities & Tooling

- **Primary Pipeline**: `~/ai/dehum/fix_video.sh`
- **MCP Server**: `~/ai/dehum/bin/mcp_dehum_server.rb`
- **Verification Harness**: `~/ai/dehum/bin/test_fix_video.sh`
- **Schema Contract**: `~/ai/dehum/schemas/forensic_telemetry.schema.json`

## The 5-Stage DSP Architecture

1. **Highpass Filtering (`highpass=f=80`)**: Rolls off sub-audible mechanical handling rumble and low-frequency wind turbulence.
2. **Impulsive De-clicking (`adeclick`)**: Cleans sharp microsecond transients caused by atmospheric ionization and high-voltage corona discharge without dulling plosive consonants.
3. **Adaptive Spectral Denoising (`afftdn=nr=18:nf=-45:tn=1`)**: Dynamic FFT spectral reduction targeting wideband induction floor.
4. **Harmonic Notch Filtering (`bandreject`)**: High-Q notch filters ($Q=30$) surgically tuned to the 60 Hz fundamental (or 50 Hz European) through its 10th harmonic (up to 600 Hz).
5. **Channel Selection & Lossless Pass-Through**:
   - Primary channel extraction (`pan=stereo|c0=c0|c1=c0`) to eliminate secondary inductive antenna crosstalk.
   - Bitstream video passthrough (`-c:v copy`) ensuring zero generational re-encoding degradation.

## Operational Rules & Invariants

> [!CRITICAL]
> **Beware the Clock-Drift Trap**: Never apply linear time-stretching (`atempo`) based solely on container header differences. Always inspect physical speech onsets at $t=10\text{s} \dots 30\text{s}$ before modifying time.
