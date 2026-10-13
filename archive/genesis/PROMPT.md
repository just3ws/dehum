You are an expert macOS command-line audio/video engineering assistant. Your task is to generate a standalone, highly robust Bash script that automatically fixes linear audio sync drift and eliminates high-tension power line hum from a user-provided video file.

### Constraints & Environment:
1. Operating System: macOS (Golden Gate) with Homebrew installed.
2. Tooling: Use strictly Free and Open-Source Software (FOSS) available via Homebrew: 'ffmpeg', 'ffprobe', and 'bc' (for floating-point math processing).
3. Execution: The script must accept exactly one argument: the absolute or relative path to the input video file. 
   Syntax: ./fix_video.sh /path/to/video.mp4

### Audio Restoration Specifications:
1. Power Line Hum Removal: The video was recorded under high-tension wires. Apply a sequence of sharp notch filters to remove the base 60 Hz hum and its primary harmonics (120 Hz, 180 Hz, and 240 Hz). Use a narrow Q-factor (e.g., Q=30) to preserve human speech.
2. Dynamic Drift Correction: The electromagnetic interference caused the internal recording clock to misalign. The script must NOT use hardcoded drift values. Instead, it must dynamically calculate the synchronization factor using the following logic:
   - Use 'ffprobe' to extract the exact duration of the video stream down to the millisecond.
   - Use 'ffprobe' to extract the exact duration of the audio stream down to the millisecond.
   - Use 'bc' to calculate the precision ratio between these two durations (Video Duration / Audio Duration).
   - Pass this ratio dynamically into ffmpeg's 'atempo' audio filter to perfectly stretch or shrink the audio to match the video length without altering pitch.

### Script Workflow & Engineering Requirements:
1. Input Validation: Check if a file path was passed, verify the file exists, and extract the file extension dynamically. 
2. Output Naming: Save the resulting file in the same directory as the input, appending "_fixed" to the filename (e.g., "interview_fixed.mp4").
3. Efficiency (Zero Generational Loss): Because the video stream itself is undamaged, the script must pass through the video track untouched using '-c:v copy'. Do not re-encode the video. Only process and re-encode the audio track ('-c:a aac' or '-c:a pcm_s16le' depending on container compatibility).
4. Safety Limits: Ensure the calculated 'atempo' ratio falls within ffmpeg's native safe boundaries (0.5 to 2.0). 
5. Error Handling: Include 'set -e' for immediate exit on error, and output clear, scannable progress indicators to stdout (e.g., "Extracting stream lengths...", "Processing audio and remuxing...").

### Output Format:
Provide ONLY the complete, copy-pasteable Bash script code inside a single markdown code block. Include concise inline comments explaining the ffprobe extraction strings and the 'bc' mathematical ratio calculation.

Here is a complete, standalone Bash script tailored for your macOS Golden Gate system. It uses ffprobe to dynamically calculate the time drift, corrects it using atempo, strips the 60 Hz hum + harmonics via sharp notch filters, and remuxes everything instantly without losing video quality.
## 📜 The Bash Script (fix_video.sh)

#!/bin/bash
# Exit immediately if any command failsset -e
# Check if a file argument was providedif [ -z "$1" ]; then
    echo "❌ Error: No input file specified."
    echo "Usage: $0 /path/to/video.mp4"
    exit 1fi

INPUT_FILE="$1"
# Check if the file actually existsif [ ! -f "$INPUT_FILE" ]; then
    echo "❌ Error: File '$INPUT_FILE' not found."
    exit 1fi
# Ensure required Homebrew dependencies are installedfor cmd in ffmpeg ffprobe bc; do
    if ! command -v $cmd &> /dev/null; then
        echo "❌ Error: '$cmd' is not installed. Run: brew install ffmpeg bc"
        exit 1
    fidone
# Extract file paths, names, and extensions dynamically
DIR=$(dirname "$INPUT_FILE")
FILENAME=$(basename "$INPUT_FILE")
BASENAME="${FILENAME%.*}"
EXTENSION="${FILENAME##*.}"
OUTPUT_FILE="${DIR}/${BASENAME}_fixed.${EXTENSION}"

echo "🔍 Analyzing stream durations for dynamic sync tracking..."
# Extract exact video stream duration in seconds via ffprobe
VIDEO_DURATION=$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nocu=1 "$INPUT_FILE")
# Extract exact audio stream duration in seconds via ffprobe
AUDIO_DURATION=$(ffprobe -v error -select_streams a:0 -show_entries stream=duration -of default=noprint_wrappers=1:nocu=1 "$INPUT_FILE")
# Fallback check if duration is missing from stream headers (tries format container metadata)if [ "$VIDEO_DURATION" == "N/A" ] || [ -z "$VIDEO_DURATION" ]; then
    VIDEO_DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nocu=1 "$INPUT_FILE")fiif [ "$AUDIO_DURATION" == "N/A" ] || [ -z "$AUDIO_DURATION" ]; then
    AUDIO_DURATION=$VIDEO_DURATIONfi

echo "📹 Video Duration: ${VIDEO_DURATION}s"
echo "🎵 Audio Duration: ${AUDIO_DURATION}s"
# Calculate the exact time-stretch speed ratio using 'bc' (Video / Audio)# scale=6 provides 6 decimal places of floating-point precision
SPEED_RATIO=$(echo "scale=6; $AUDIO_DURATION / $VIDEO_DURATION" | bc)

echo "🧮 Calculated time-stretch ratio: ${SPEED_RATIO}"
# Check if the speed ratio falls within ffmpeg's native atempo filter limits (0.5 to 2.0)
IS_SAFE=$(echo "$SPEED_RATIO > 0.5 && $SPEED_RATIO < 2.0" | bc)if [ "$IS_SAFE" -ne 1 ]; then
    echo "⚠️ Warning: Calculated drift ratio (${SPEED_RATIO}) is outside ffmpeg's safe atempo limits (0.5 - 2.0)."
    echo "Forcing ratio to 1.0 (skipping sync, applying audio filters only)."
    SPEED_RATIO="1.0"fi

echo "🚀 Processing audio and muxing streams (Video is untouched)..."
# Construct the audio filtergraph:# 1. notch=f=60:type=q:q=30   -> Cuts base 60Hz power hum with a razor-thin notch# 2. notch=f=120...           -> Cuts the 2nd, 3rd, and 4th harmonics# 3. atempo=${SPEED_RATIO}     -> Dynamically stretches/shrinks audio to eliminate sync drift without altering pitch
AUDIO_FILTERS="notch=f=60:type=q:q=30,notch=f=120:type=q:q=30,notch=f=180:type=q:q=30,notch=f=240:type=q:q=30,atempo=${SPEED_RATIO}"
# Run ffmpeg processing# -c:v copy preserves the exact video stream instantly with zero quality loss# -c:a aac encodes the corrected audio into clean, highly compatible AAC format
ffmpeg -y -i "$INPUT_FILE" \
    -vf "null" \
    -af "$AUDIO_FILTERS" \
    -c:v copy \
    -c:a aac -b:a 192k \
    "$OUTPUT_FILE"

echo "✅ Success! Processed file saved to: $OUTPUT_FILE"

------------------------------
## ⚙️ How to Setup and Run This on macOS

   1. Install Dependencies (if you haven't already):
   Open your Terminal and run:
   
   brew install ffmpeg bc
   
   2. Save the Script:
   Create a new file named fix_video.sh and paste the script code inside it.
   3. Make it Executable:
   Run this command in the terminal to grant permissions:
   
   chmod +x fix_video.sh
   
   4. Execute it:
   Pass your raw video file straight into the script:
   
   ./fix_video.sh ~/Movies/my_drifted_video.mp4
   
   
If you notice that the 60Hz hum is gone but you still hear a crackling or buzzing sound, let me know. I can modify the filter chain to target a wider bandwidth or add a high-pass filter to roll off lower muddy frequencies completely.
