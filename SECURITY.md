# Security Policy

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| latest  | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

1. **Do NOT open a public issue**
2. Use [GitHub Security Advisories](https://github.com/gabrielursan-beep/red-alert-llm/security/advisories/new) to report privately
3. Include: description, steps to reproduce, potential impact
4. You will receive a response within 72 hours

## Security Design Principles

Red Alert LLM is designed with security in mind:

- **Zero network access** — the AI and knowledge base run 100% offline
- **No telemetry** — nothing is sent anywhere, ever
- **Encrypted vault** — personal data protected with AES-256 via VeraCrypt
- **No installation** — nothing is written to the host system
- **Localhost binding** — AI server binds to 127.0.0.1 only (not exposed to network)
- **Open source** — all code is auditable

## Known Considerations

- ExFAT filesystem has no encryption — files outside the VeraCrypt vault are readable by anyone with physical access
- AI models can hallucinate — do not rely on AI output for medical or legal decisions without verification
- Always safely eject the SSD to prevent data corruption (ExFAT has no journaling)
