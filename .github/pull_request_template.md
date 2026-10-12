## Sovereign Verification Pull Request Checklist

> *"Code generation is free. Verification is everything."*

### 1. Change Archetype
- [ ] Forensic Audio DSP filter adjustment
- [ ] Container muxing / timestamp synchronization
- [ ] Documentation, case study, or economic ledger update
- [ ] Automated security guard / TMI boundary check

---

### 2. Physical Ground Truth Verification
- [ ] **Empirical Audio Integrity**: Have you listened to the processed WAV/AAC output on studio headphones or IEMs?
- [ ] **No Artificial Crystal Drift**: Verified that `atempo` is NOT being applied to disguise trailing silence or hardware cutoff?
- [ ] **Lossless Video**: Is video being passed through with `-c:v copy` (zero generation loss)?
- [ ] **Phase & Frequency Check**: Confirmed that notch filters ($Q=30$) do not cause audible phase smearing or intelligibility loss on speech formants?

---

### 3. Automated Guard Rails
- [ ] Ran `./test_fix_video.sh` with 100% exit code 0.
- [ ] Ran `ruby bin/audit_tmi.rb` with 0 PII / PHI / home path disclosures.
- [ ] Verified POSIX syntax via `bash -n fix_video.sh`.

---

### 4. The Classic Loki Assessment
- [ ] **Glorious Purpose Check**: Does this change solve an actual physical problem, or does it merely spin up green-light artifice that slows the monster down?
- [ ] **Mjolnir Check**: If the lightning arcs through the ground, are you prepared to stand in front of the audience with the raw waveforms?
