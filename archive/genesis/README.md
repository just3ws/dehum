# Project Genesis Artifacts (Pre-Git Inception)

This directory preserves the historical genesis artifacts captured on October 9, 2026, before the git repository was initialized.

---

## Provenance & Timeline

1. **The Origin Query**:
   The investigation did not begin in a terminal or IDE. It began in Google Chrome on google.com with the search query:
   `recording a video under high tension wires repair audio sync`
   The raw browser capture is preserved in `archive/google_search_research/`.

2. **`PROMPT.md`**:
   The Google Gemini search overview synthesized what appeared to be an authoritative engineering specification with notch filter pole frequencies, Butterworth recommendations, and `atempo` duration ratio calculations. The maintainer saved this browser-generated output locally as `PROMPT.md` to feed into an autonomous terminal agent.

3. **`gemini_transcript.md`**:
   The verbatim terminal transcript from the very first Gemini CLI session using Google Antigravity (Gemini 3.8 Flash). The agent parsed `PROMPT.md`, ran `ffprobe` on `VID_20261009_111445043.mp4`, fell into the naive container-drift trap (`atempo=0.837`), and created the initial version of `fix_video.sh`.

These artifacts document how plausible AI hallucinations take root at the very start of a workflow, well before the first commit is made in version control.
