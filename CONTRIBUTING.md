# Contributing to `dehum`

Thank you for your interest in contributing to **`just3ws/dehum`**!

This project is an open forensic exercise and public inquiry into digital signal processing, generative AI leverage traps, and physical ground truth verification.

---

## 1. Ground Rules & Principles

- **No Generational Loss**: Never touch video frames if video isn't corrupted. Always use `-c:v copy`.
- **Listen Before You Push**: If you modify audio filters, listen on studio monitors or headphones. If speech sounds robotic or phase-smeared, it fails review.
- **Run the Gates**: All contributions must pass the local and CI gates:
  ```bash
  # 1. Run unit test suite
  ./test_fix_video.sh

  # 2. Run TMI/PII/PHI security scan
  ruby bin/audit_tmi.rb

  # 3. Verify shell syntax
  bash -n fix_video.sh
  ```

---

## 2. Pull Request Workflow

1. Fork the repo and create your branch from `main`.
2. Ensure commit messages follow Conventional Commits (`fix:`, `feat:`, `docs:`, `test:`).
3. Complete the [Pull Request Checklist](.github/pull_request_template.md).
4. Do not include hardcoded absolute home directories, personal contact info, or PII.

---

## 3. Dual Licensing Consent

By contributing to this repository, you agree that your contributions will be dual-licensed:
- **Code & Scripts**: Under the [MIT License](LICENSE.md).
- **Documentation & Analysis**: Under [CC BY-SA 4.0](LICENSE.md).
