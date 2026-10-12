#!/bin/bash
# ==============================================================================
# fix_video.sh - Audio restoration & linear drift sync for macOS/Linux
# Removes 60 Hz hum, high-voltage corona crackle, and dynamic clock drift.
# ==============================================================================

set -euo pipefail

VERSION="1.3.0"
HIGHPASS_FREQ=90
Q_FACTOR=15
HARMONICS_COUNT=10
BASE_FREQ=60
ENABLE_DECLICK=true
DECLICK_THRESH=2
ENABLE_DENOISE=true
ENABLE_GATE=true
LOWPASS_FREQ=4000
CHANNEL_MODE="left"
DRY_RUN=false
CUSTOM_OUTPUT=""
INPUT_FILE=""
DO_STRETCH=false

show_help() {
    cat << 'EOF'
NAME
    fix_video.sh - Automatic audio dehum, de-crackle, and sync drift repair

SYNOPSIS
    fix_video.sh [OPTIONS] <input_video_or_audio>

DESCRIPTION
    Automates multi-stage audio restoration and dynamic AV clock drift
    correction for video files recorded under high-tension power lines or
    affected by electromagnetic clock misalignment.

    The restoration pipeline operates in 5 DSP stages:
      1. Highpass Filter: Rolls off sub-audio handling rumble (< 80 Hz).
      2. Impulsive De-clicker (adeclick): Eliminates sharp micro-arcing
         corona discharge impulses and click spikes.
      3. FFT Denoiser (afftdn): Adaptive spectral noise reduction to
         suppress broadband electromagnetic induction floor.
      4. Harmonic Notch Filters (bandreject): High-Q notches targeting 60 Hz
         and up to 10 harmonics (120, 180, ..., 600 Hz) to eliminate buzz.
      5. Dynamic Drift Correction (atempo): Computes exact duration ratio
         via ffprobe and stretches/compresses audio to match video duration.

    The video stream is passed through bit-for-bit (-c:v copy) without
    re-encoding or generational quality loss.

OPTIONS
    -h, --help
        Display this help documentation and exit.

    -v, --version
        Display script version and exit.

    -n, --dry-run
        Analyze durations and output calculated atempo speed ratio and
        generated FFmpeg filtergraph without executing audio re-encoding.

    -o, --output <path>
        Specify custom output filename. Defaults to <input_basename>_fixed.<ext>.

    --highpass <Hz>
        Set cutoff frequency for sub-rumble highpass filter (default: 80).
        Set to 0 to disable highpass filter.

    --q-factor <Q>
        Set notch filter Q factor (default: 30). Higher Q narrows the notch
        to preserve adjacent speech frequencies.

    --harmonics <N>
        Number of 60 Hz harmonics to notch (default: 10, i.e. 60 Hz through 600 Hz).

    --base-freq <Hz>
        Base power line frequency (default: 60 for US/Americas, set to 50 for Europe).

    --no-declick
        Disable the impulsive noise/crackle removal stage (adeclick).

    --no-denoise
        Disable adaptive FFT spectral noise reduction (afftdn).

    --channel <left|right|stereo>
        Select audio channel mapping (default: left). Phones record with dual
        mics where the secondary/top mic is frequently overwhelmed by EMI
        induction (SNR ~1.0). Selecting 'left' duplicates the clean primary
        channel to both stereo channels (pan=stereo|c0=c0|c1=c0).

    --stretch
        Force dynamic time-stretching via atempo (default is to preserve natural
        1.0x speed and lip-sync, padding trailing silence with apad to video length).

EXAMPLES
    # Fix video with default auto-sync and dehum/de-crackle:
    ./fix_video.sh /path/to/recording.mp4

    # Preview calculated drift ratio without processing:
    ./fix_video.sh --dry-run /path/to/recording.mp4

    # Specify custom output path:
    ./fix_video.sh -o /path/to/cleaned.mp4 /path/to/recording.mp4

    # Target 50 Hz European electrical grid:
    ./fix_video.sh --base-freq 50 /path/to/recording.mp4

DEPENDENCIES
    Requires ffmpeg, ffprobe, and bc (available via Homebrew: brew install ffmpeg bc).

EOF
}

show_version() {
    echo "fix_video.sh version $VERSION"
}

# Parse command line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            show_version
            exit 0
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -o|--output)
            CUSTOM_OUTPUT="$2"
            shift 2
            ;;
        --highpass)
            HIGHPASS_FREQ="$2"
            shift 2
            ;;
        --q-factor)
            Q_FACTOR="$2"
            shift 2
            ;;
        --harmonics)
            HARMONICS_COUNT="$2"
            shift 2
            ;;
        --base-freq)
            BASE_FREQ="$2"
            shift 2
            ;;
        --no-declick)
            ENABLE_DECLICK=false
            shift
            ;;
        --no-denoise)
            ENABLE_DENOISE=false
            shift
            ;;
        --lowpass)
            LOWPASS_FREQ="$2"
            shift 2
            ;;
        --channel)
            CHANNEL_MODE="$2"
            shift 2
            ;;
        --declick-thresh)
            DECLICK_THRESH="$2"
            shift 2
            ;;
        --stretch)
            DO_STRETCH=true
            shift
            ;;
        --)
            shift
            INPUT_FILE="$1"
            shift
            break
            ;;
        -*)
            echo "❌ Unknown option: $1" >&2
            echo "Try '$0 --help' for more information." >&2
            exit 1
            ;;
        *)
            if [ -z "$INPUT_FILE" ]; then
                INPUT_FILE="$1"
                shift
            else
                echo "❌ Unexpected extra argument: $1" >&2
                echo "Try '$0 --help' for more information." >&2
                exit 1
            fi
            ;;
    esac
done

if [ -z "$INPUT_FILE" ]; then
    echo "❌ Error: No input file specified." >&2
    echo "Usage: $0 [OPTIONS] /path/to/video.mp4" >&2
    echo "Run '$0 --help' for full options and manual." >&2
    exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ Error: File '$INPUT_FILE' not found." >&2
    exit 1
fi

# Ensure required dependencies are installed
for cmd in ffmpeg ffprobe bc; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "❌ Error: '$cmd' is not installed. Run: brew install ffmpeg bc" >&2
        exit 1
    fi
done

# Extract file paths, names, and extensions dynamically
DIR=$(dirname "$INPUT_FILE")
FILENAME=$(basename "$INPUT_FILE")
BASENAME="${FILENAME%.*}"
EXTENSION="${FILENAME##*.}"

if [ -n "$CUSTOM_OUTPUT" ]; then
    OUTPUT_FILE="$CUSTOM_OUTPUT"
else
    OUTPUT_FILE="${DIR}/${BASENAME}_fixed.${EXTENSION}"
fi

echo "🔍 Analyzing stream durations for dynamic sync tracking..."

# Extract exact video stream duration in seconds via ffprobe
VIDEO_DURATION=$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT_FILE")

# Extract exact audio stream duration in seconds via ffprobe
AUDIO_DURATION=$(ffprobe -v error -select_streams a:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT_FILE")

# Fallback check if duration is missing from stream headers (tries format container metadata)
if [ "$VIDEO_DURATION" = "N/A" ] || [ -z "$VIDEO_DURATION" ]; then
    VIDEO_DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT_FILE")
fi
if [ "$AUDIO_DURATION" = "N/A" ] || [ -z "$AUDIO_DURATION" ]; then
    AUDIO_DURATION="$VIDEO_DURATION"
fi

echo "📹 Video Duration: ${VIDEO_DURATION}s"
echo "🎵 Audio Duration: ${AUDIO_DURATION}s"

# Calculate the exact time-stretch speed ratio using 'bc' (Audio / Video)
# scale=6 provides 6 decimal places of floating-point precision
SPEED_RATIO=$(echo "scale=6; $AUDIO_DURATION / $VIDEO_DURATION" | bc)

# Ensure leading zero for fractions (e.g. .836979 -> 0.836979)
case "$SPEED_RATIO" in
    .*) SPEED_RATIO="0${SPEED_RATIO}" ;;
esac

echo "🧮 Calculated time-stretch ratio: ${SPEED_RATIO}"

# Check if the speed ratio falls within ffmpeg's native atempo filter limits (0.5 to 2.0)
IS_SAFE=$(echo "$SPEED_RATIO >= 0.5 && $SPEED_RATIO <= 2.0" | bc)
if [ "$IS_SAFE" -ne 1 ]; then
    echo "⚠️ Warning: Calculated drift ratio (${SPEED_RATIO}) is outside ffmpeg's safe atempo limits (0.5 - 2.0)." >&2
    echo "Forcing ratio to 1.0 (skipping sync, applying audio filters only)." >&2
    SPEED_RATIO="1.0"
fi

# Select audio codec based on container extension
EXTENSION_LOWER=$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')
case "$EXTENSION_LOWER" in
    wav)
        AUDIO_CODEC="pcm_s16le"
        AUDIO_CODEC_ARGS=()
        ;;
    *)
        AUDIO_CODEC="aac"
        AUDIO_CODEC_ARGS=("-b:a" "192k")
        ;;
esac

# Build filtergraph dynamically
FILTER_PARTS=()

# Stage 0: Channel selection / isolation
case "$CHANNEL_MODE" in
    left)
        FILTER_PARTS+=("pan=stereo|c0=c0|c1=c0")
        ;;
    right)
        FILTER_PARTS+=("pan=stereo|c0=c1|c1=c1")
        ;;
    stereo)
        # Leave original stereo channels
        ;;
    *)
        echo "❌ Invalid --channel option: $CHANNEL_MODE (expected: left, right, stereo)" >&2
        exit 1
        ;;
esac

# Stage 1: Highpass filter for sub-audio mud/rumble
if [ "$HIGHPASS_FREQ" -gt 0 ]; then
    FILTER_PARTS+=("highpass=f=${HIGHPASS_FREQ}")
fi

# Stage 2: Impulsive click/crackle removal (adeclick with tuned window & overlap)
if [ "$ENABLE_DECLICK" = true ]; then
    FILTER_PARTS+=("adeclick=w=30:o=75:t=${DECLICK_THRESH}:b=3")
fi

# Stage 3: FFT denoiser (afftdn with gain smoothing)
if [ "$ENABLE_DENOISE" = true ]; then
    FILTER_PARTS+=("afftdn=nr=18:nf=-45:nt=c:gs=10")
fi

# Stage 4: High-Q Notch filters for base frequency and harmonics (Q=15)
for (( i=1; i<=HARMONICS_COUNT; i++ )); do
    f_harmonic=$(( BASE_FREQ * i ))
    FILTER_PARTS+=("bandreject=f=${f_harmonic}:width_type=q:w=${Q_FACTOR}")
done

# Stage 5: Voice Lowpass smoothing (removes residual high-frequency electrical hiss/sizzle)
if [ "$LOWPASS_FREQ" -gt 0 ]; then
    FILTER_PARTS+=("lowpass=f=${LOWPASS_FREQ}")
fi

# Stage 6: Downward Expander Gate (suppresses background hum and induction during speech pauses)
if [ "$ENABLE_GATE" = true ]; then
    FILTER_PARTS+=("agate=threshold=0.012:ratio=2.5:attack=15:release=150:range=0.1")
fi

# Stage 7: Sync Alignment: stretch only if explicitly requested, otherwise pad to video length
if [ "$DO_STRETCH" = true ]; then
    FILTER_PARTS+=("atempo=${SPEED_RATIO}")
else
    FILTER_PARTS+=("apad=whole_dur=${VIDEO_DURATION}")
fi

# Join filter parts with comma
IFS="," eval 'AUDIO_FILTERS="${FILTER_PARTS[*]}"'

if [ "$DRY_RUN" = true ]; then
    echo "--------------------------------------------------------"
    echo "DRY RUN SUMMARY:"
    echo "  Input File:     $INPUT_FILE"
    echo "  Output Target:  $OUTPUT_FILE"
    echo "  Video Duration: ${VIDEO_DURATION}s"
    echo "  Audio Duration: ${AUDIO_DURATION}s"
    echo "  Speed Ratio:    ${SPEED_RATIO}"
    echo "  Audio Codec:    ${AUDIO_CODEC}"
    echo "  Audio Filters:"
    echo "    $AUDIO_FILTERS"
    echo "--------------------------------------------------------"
    exit 0
fi

echo "🚀 Processing audio and remuxing streams (Video is untouched)..."

ffmpeg -y -i "$INPUT_FILE" \
    -af "$AUDIO_FILTERS" \
    -c:v copy \
    -c:a "$AUDIO_CODEC" "${AUDIO_CODEC_ARGS[@]}" \
    -shortest \
    "$OUTPUT_FILE"

echo "✅ Success! Processed file saved to: $OUTPUT_FILE"
