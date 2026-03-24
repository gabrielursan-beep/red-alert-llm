# Contributing to Red Alert LLM

Thank you for your interest in contributing! This project aims to make AI accessible to everyone, even without internet access.

## How to Contribute

### Reporting Bugs
Use the [Bug Report template](https://github.com/gabrielursan-beep/red-alert-llm/issues/new?template=bug_report.yml).

### Suggesting Features
Use the [Feature Request template](https://github.com/gabrielursan-beep/red-alert-llm/issues/new?template=feature_request.yml).

### Pull Requests
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Make your changes
4. Test on at least one platform (Windows, macOS, or Linux)
5. Ensure all scripts remain portable (no hardcoded paths)
6. Ensure everything works **offline** — no runtime internet dependencies
7. Submit a pull request using the PR template

### Code Guidelines
- Shell scripts must be POSIX-compatible where possible
- Windows batch files must work on Windows 10+
- All paths must be relative to the project root
- No telemetry, no analytics, no phoning home — ever
- Keep the project zero-install: no system-level dependencies
- Bilingual (English + Romanian) for user-facing text

### What We Need Help With
- Testing on more hardware configurations
- Translating the interface and docs to more languages
- Adding more offline knowledge bases (ZIM files)
- Improving AI model selection logic
- Android and iOS launcher improvements
- Documentation and tutorials
- Performance benchmarks on different hardware

## Code of Conduct
Please read our [Code of Conduct](CODE_OF_CONDUCT.md) before participating.
