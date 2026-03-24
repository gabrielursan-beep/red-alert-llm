# 🔴 Red Alert LLM — Portable Offline AI & Knowledge Base

**Carry an AI assistant and the world's knowledge on a USB stick. No internet. No installation. No subscriptions.**

---

## What Is This?

Red Alert LLM is a portable offline AI toolkit that runs entirely from a USB SSD. Plug it into any computer or phone and get:

- **AI Chat Assistant** — talk to an AI in 119 languages (including Romanian) powered by Qwen3, running locally on your hardware
- **Offline Wikipedia** — full English Wikipedia (6.8M articles), Romanian Wikipedia, medical encyclopedia, repair guides, and more
- **Encrypted Vault** — 200 GB password-protected storage for personal documents, medical records, passwords
- **Cross-Platform** — works on Windows, macOS, Linux, Android, and iOS

Everything runs offline. Your data never leaves your device.

---

## Hardware Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **RAM** | 6 GB | 8-16 GB |
| **USB Port** | USB 3.0 | USB 3.2 Gen 2 |
| **OS** | Windows 10, macOS 12+, Android 8+ | Windows 11, macOS 14+, iOS 16+ |
| **Storage** | 256 GB USB drive | **Kingston 1TB Dual Portable SSD** |
| **CPU** | Any x64 / ARM64 | Apple Silicon (M1+) or modern Intel/AMD |

### Recommended SSD

**SSD Portabil Dual Kingston, 1TB, USB Type-A/USB Type-C, USB 3.2 Gen 2** — 1,050 MB/s, 28g, keychain-sized.
[Buy on eMAG.ro — 743 RON](https://bit.ly/4uEu0nA)*

*\* Affiliate link — purchasing through this link supports the project at no extra cost to you.*

---

## Quick Start

### Step 1: Clone the Repository

```bash
git clone https://github.com/gabrielursan-beep/red-alert-llm.git
```

Copy the entire `red-alert-llm/` folder to your USB SSD root.

### Step 2: Run Setup

**Windows** — double-click `setup/setup-windows.bat`
**macOS** — open Terminal, run:
```bash
cd /Volumes/YOUR_SSD/red-alert-llm
chmod +x setup/setup-mac.sh
./setup/setup-mac.sh
```

The setup script downloads:
- AI engines (llamafile + KoboldCpp) — ~800 MB
- AI model (Qwen3 — size depends on your RAM) — 2.5-9 GB
- Kiwix reader — ~200 MB

### Step 3: Download Knowledge Bases

```bash
# On any OS with bash (macOS, Linux, Git Bash on Windows):
chmod +x setup/download-knowledge.sh
./setup/download-knowledge.sh
```

This downloads Wikipedia and other offline knowledge bases. Choose which ones you want — from 55 GB (minimal) to 200 GB (full).

### Step 4: Launch

**Windows** — double-click `launchers/start-windows.bat`
**macOS** — double-click `launchers/start-macos.command`

The launcher:
1. Detects your RAM and selects the best AI model
2. Starts the AI server
3. Opens your browser to `http://localhost:8080`
4. You can start chatting!

---

## What's Included

### AI Models

| Model | Size | RAM Needed | Best For |
|-------|------|-----------|----------|
| **Qwen3-4B** | 2.5 GB | 8 GB | Standard use, phones |
| **Qwen3-8B** | 5 GB | 12 GB | Enhanced reasoning |
| **Qwen3-14B** | 9 GB | 16 GB | Premium quality |
| Gemma-3-4B | 2.5 GB | 8 GB | Alternative (Google) |

The setup script auto-downloads the best model for your RAM. A mobile-optimized Qwen3-4B (Q3_K_M, 2 GB) is also downloaded for phone use.

The launcher automatically selects the best model for your hardware.

### Knowledge Bases (Kiwix ZIM Files)

| Content | Size | Description |
|---------|------|-------------|
| Wikipedia EN (full) | 115 GB | Complete English Wikipedia with images |
| Wikipedia EN (text) | 48 GB | Same articles, no images (lighter) |
| Wikipedia RO (full) | 10.6 GB | Complete Romanian Wikipedia |
| WikiMed Medical | 2.1 GB | 73,000+ medical articles |
| iFixit Repairs | 3.3 GB | Electronics & device repair guides |
| Wiktionary EN | 8.2 GB | English dictionary + etymology |
| Wikivoyage | 1 GB | Travel guides worldwide |
| SuperUser Q&A | 3.7 GB | Computer troubleshooting |
| DIY Home Repair | 1.9 GB | Home improvement Q&A |

### Encrypted Vault

A 200 GB VeraCrypt container (`vault.hc`) for:
- Personal documents and ID scans
- Medical records and prescriptions
- Financial documents and tax returns
- Password database (KeePass)
- Photo backups

Encrypted with AES-256. Only accessible with your password.

---

## Performance

| Hardware | Model | Speed |
|----------|-------|-------|
| MacBook Air M1 (8 GB) | Qwen3-4B | ~25-35 tok/s |
| MacBook Pro M2 (16 GB) | Qwen3-8B | ~40-55 tok/s |
| MacBook Pro M3 Pro (36 GB) | Qwen3-14B | ~50-70 tok/s |
| Windows Intel i5 (16 GB) | Qwen3-4B | ~10-18 tok/s |
| Windows + RTX 3060 | Qwen3-8B | ~40-60 tok/s |
| iPhone 15 Pro (8 GB) | Qwen3-4B | ~15-20 tok/s |
| Samsung S24 (12 GB) | Qwen3-4B | ~10-15 tok/s |

**What matters most:** memory bandwidth (Apple Silicon > DDR5 > DDR4) and GPU acceleration (Metal on Mac, CUDA on NVIDIA).

---

## Platform Support

| Platform | AI Chat | Wikipedia | Encrypted Vault | Setup Difficulty |
|----------|---------|-----------|-----------------|-----------------|
| **Windows 10/11** | ✅ Zero install | ✅ Portable | ✅ Portable | Easy |
| **macOS (Apple Silicon)** | ✅ One command | ✅ App Store | ⚠️ Needs macFUSE | Easy |
| **macOS (Intel)** | ✅ CPU only | ✅ App Store | ⚠️ Needs macFUSE | Easy |
| **Linux** | ✅ Zero install | ✅ AppImage | ✅ Install | Easy |
| **Android** | ✅ Via PocketPal AI | ✅ Via Kiwix APK | ❌ Not supported | Medium |
| **iOS / iPadOS** | ⚠️ Copy model first | ⚠️ Copy ZIM first | ❌ Not supported | Hard |

### Android Guide
1. Connect SSD to phone via USB-OTG cable
2. Install PocketPal AI (Play Store) or sideload the APK from `apps/android/`
3. Copy `models/mobile/qwen3-4b-q3_k_m.gguf` to your phone storage
4. Open PocketPal AI, load the model file
5. For Wikipedia: install Kiwix APK from `apps/android/kiwix-android-full.apk`
6. Open ZIM files directly from the USB SSD in Kiwix

### iOS Guide
1. Connect SSD to iPhone/iPad via USB-C (or Lightning adapter)
2. Install PocketPal AI from App Store
3. Open Files app, navigate to the SSD, copy `models/mobile/qwen3-4b-q3_k_m.gguf` to "On My iPhone"
4. Open PocketPal AI, import the model
5. For Wikipedia: install Kiwix from App Store, copy a ZIM file to your device

---

## Project Structure

```
RED-ALERT-LLM/
├── START-HERE.html          # Open in browser — guides you through everything
├── README.md                # This file
├── engines/                 # AI inference engines (llamafile, KoboldCpp)
├── models/                  # AI model files (.gguf)
│   ├── primary/             # Qwen3 4B/8B/14B
│   ├── alternatives/        # Gemma 3 4B/12B
│   ├── specialized/         # Whisper (speech-to-text)
│   └── mobile/              # Smaller quants for phones
├── knowledge/               # Wikipedia and other ZIM files
├── apps/                    # Kiwix, VeraCrypt, Android APKs
├── setup/                   # One-click setup scripts
├── launchers/               # One-click launcher scripts
├── tools/                   # Verification and utility scripts
├── vault.hc                 # 200 GB encrypted container
├── config/                  # Model and knowledge base registries
└── docs/                    # Detailed guides and troubleshooting
```

---

## FAQ

**Q: Is it really free?**
A: Yes. All software (llamafile, KoboldCpp, Kiwix, models) is open-source and free. You only pay for the USB SSD.

**Q: Does the AI need internet?**
A: No. Everything runs locally. The AI model loads into your computer's RAM from the SSD.

**Q: How good is the AI compared to ChatGPT?**
A: Qwen3-14B is roughly comparable to GPT-3.5 for most tasks. It's excellent for Q&A, translation, coding help, and general knowledge. It won't match GPT-4/Claude for complex reasoning, but it's free and private.

**Q: Can I use this on a regular USB flash drive?**
A: Yes, but loading will be slower (30-60 seconds vs 3-10 seconds on an SSD). Once loaded, speed depends on RAM, not USB speed.

**Q: Is my data safe in the encrypted vault?**
A: VeraCrypt uses AES-256 encryption. Without your password, the data is effectively unreadable. Always safely eject the SSD to prevent corruption.

**Q: Can multiple people on the same WiFi use the AI?**
A: Yes, but you need to edit the launcher script first — change `--host 127.0.0.1` to `--host 0.0.0.0`. Then other devices on the same WiFi can access `http://YOUR_IP:8080` for AI chat. See TECH.md for details.

---

## 🇷🇴 Ghid in Limba Romana

### Ce este Red Alert LLM?

Red Alert LLM este un kit AI portabil care functioneaza offline, de pe un SSD USB. Conectezi SSD-ul la orice computer sau telefon si ai acces la:

- **Asistent AI** — vorbesti cu un AI in romana (si alte 118 limbi) fara internet
- **Wikipedia Offline** — Wikipedia completa in engleza si romana, enciclopedie medicala, ghiduri de reparatii
- **Seif Criptat** — 200 GB spatiu protejat cu parola pentru documente personale
- **Multi-platforma** — functioneaza pe Windows, macOS, Linux, Android si iOS

### Ce ai nevoie

- **SSD USB**: [SSD Portabil Dual Kingston 1TB](https://bit.ly/4uEu0nA) — 743 RON pe eMAG.ro*
- **Computer cu minim 8 GB RAM** (sau telefon cu minim 4 GB RAM)
- **Port USB 3.0** (sau USB-C pe telefon cu OTG)

### Pornire rapida

1. **Cloneaza repository-ul** si copiaza pe SSD
2. **Ruleaza setup-ul**: dublu-click pe `setup/setup-windows.bat` (Windows) sau ruleaza `setup/setup-mac.sh` (macOS)
3. **Descarca Wikipedia**: ruleaza `setup/download-knowledge.sh` si alege ce vrei
4. **Lanseaza AI-ul**: dublu-click pe `launchers/start-windows.bat` (Windows) sau `launchers/start-macos.command` (macOS)
5. Se deschide browserul la `http://localhost:8080` — incepe sa vorbesti cu AI-ul!

### De ce Qwen3?

Qwen3 este cel mai bun model AI open-source pentru limba romana:
- Suporta 119 limbi (inclusiv romana nativ, nu tradus)
- Are "mod de gandire" — poate rationa pas cu pas inainte sa raspunda
- Modelul de 4B parametri merge pe orice computer cu 8 GB RAM
- Modelul de 14B parametri are calitate apropiata de ChatGPT

### Performanta asteptata

| Hardware | Model | Viteza |
|----------|-------|--------|
| MacBook Air M1 (8 GB) | Qwen3-4B | ~25-35 cuvinte/s |
| PC cu Intel i5 (16 GB) | Qwen3-4B | ~10-18 cuvinte/s |
| PC cu RTX 3060 | Qwen3-8B | ~40-60 cuvinte/s |
| iPhone 15 Pro | Qwen3-4B | ~15-20 cuvinte/s |

### Pe telefon (Android)

1. Conecteaza SSD-ul la telefon cu cablu USB-OTG
2. Instaleaza PocketPal AI din Play Store (sau din `apps/android/`)
3. Copiaza `models/mobile/qwen3-4b-q3_k_m.gguf` pe telefon (~2 GB)
4. Deschide PocketPal AI si incarca modelul
5. Pentru Wikipedia: instaleaza Kiwix APK din `apps/android/`

### Pe telefon (iOS)

1. Conecteaza SSD-ul la iPhone cu USB-C
2. Instaleaza PocketPal AI din App Store
3. Din Files, copiaza modelul de pe SSD pe iPhone (~2 GB)
4. Deschide PocketPal AI si importa modelul
5. Pentru Wikipedia: instaleaza Kiwix din App Store, copiaza un fisier ZIM

### Ghid complet

Vezi `docs/GHID-COMPLET-RO.md` pentru instructiuni detaliate pas cu pas.

---

## Credits

- [llamafile](https://github.com/mozilla-ai/llamafile) by Mozilla — portable AI inference engine
- [KoboldCpp](https://github.com/LostRuins/koboldcpp) by Concedo — alternative AI engine with rich UI
- [Qwen3](https://github.com/QwenLM/Qwen3) by Alibaba — AI models with 119 language support
- [Gemma 3](https://ai.google.dev/gemma) by Google — multilingual AI models
- [Kiwix](https://www.kiwix.org/) — offline knowledge reader
- [VeraCrypt](https://www.veracrypt.fr/) — disk encryption
- [PocketPal AI](https://www.pocketpal.dev/) — mobile AI app
- Wikipedia contributors worldwide

## License

MIT License — see [LICENSE](LICENSE) file.

---

*Built for emergencies. Built for privacy. Built for freedom.*
