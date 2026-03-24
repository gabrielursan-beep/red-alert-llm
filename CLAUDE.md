# Red Alert LLM — Claude Code Instructions

## Project Purpose
Portable offline AI assistant + knowledge base + encrypted personal vault on a Kingston 1TB Dual Portable SSD (USB-A + USB-C, USB 3.2 Gen 2, ExFAT). Cross-platform: Windows, macOS, Linux, Android, iOS.

## Affiliate & Pricing Note
- SSD affiliate link (eMAG.ro): https://bit.ly/4uEu0nA
- Product: SSD Portabil Dual Kingston, 1TB, USB Type-A/USB Type-C, USB 3.2 Gen 2, rosu/negru
- Price: 743 RON (as of 24 March 2026)
- All eMAG links in docs use this affiliate link. Be transparent about it in all documentation.
- Do NOT estimate prices for alternative SSDs. Only state the verified Kingston price.

## Target Audience
Romanian users (and anyone) who want offline AI access for emergencies, travel, privacy, or areas with no internet. End product must be usable by complete beginners — scripts self-explanatory, bilingual (EN + RO).

## Tech Stack

### LLM Inference Engines
- **llamafile v0.10.0** (Mozilla) — primary engine, single executable, runs on Win/Mac/Linux, built-in web UI at :8080
  - GitHub: https://github.com/mozilla-ai/llamafile/releases/tag/0.10.0
  - Binary: https://github.com/mozilla-ai/llamafile/releases/download/0.10.0/llamafile-0.10.0
  - Does NOT run on Android or iOS
- **KoboldCpp v1.110** — secondary engine, richer UI (KoboldAI Lite), single executable
  - GitHub: https://github.com/LostRuins/koboldcpp/releases/tag/v1.110
  - Win (no CUDA): koboldcpp-nocuda.exe (92 MB)
  - macOS ARM64: koboldcpp-mac-arm64 (44 MB)
  - Linux: koboldcpp-linux-x64-nocuda (109 MB)
  - Has Termux auto-installer for Android (v1.90.2+)

### AI Models (GGUF format, Q4_K_M quantization)
| Model | Size | Min RAM | Languages | Romanian | Use Case |
|-------|------|---------|-----------|----------|----------|
| Qwen3-4B | 2.5 GB | 6 GB | 119 | Yes | Primary — phones + low RAM PCs |
| Qwen3-8B | 5.0 GB | 10 GB | 119 | Yes | Enhanced — 12GB+ RAM |
| Qwen3-14B | 9.0 GB | 14 GB | 119 | Yes | Premium — 16GB+ RAM |
| Gemma-3-4B-IT | 2.5 GB | 6 GB | 140+ | Yes | Alternative — multimodal |
| Gemma-3-12B-IT | 7.0 GB | 12 GB | 140+ | Yes | Alternative — larger |
| Whisper-large-v3 | 3.0 GB | 4 GB | 99 | Yes | Speech-to-text |

Model sources:
- Qwen3: https://huggingface.co/Qwen/Qwen3-4B-GGUF (and 8B, 14B)
- Gemma 3: https://huggingface.co/ggml-org/gemma-3-4b-it-GGUF
- Also check bartowski repos for Q4_K_M quants

### Knowledge Base
- **Kiwix Desktop** — offline reader for ZIM files (Win/Mac/Linux/Android/iOS)
  - Download: https://kiwix.org/en/applications/
  - ZIM catalog: https://download.kiwix.org/zim/
  - Android: use FULL APK from website, NOT Play Store (scoped storage issues)
  - iOS: App Store, but must copy ZIM to device storage
- **kiwix-serve** — serve ZIM over local network (any device with a browser)

### Encrypted Vault
- **VeraCrypt Portable** — 200 GB encrypted container (vault.hc)
  - AES-256, SHA-512, ExFAT internal filesystem
  - Works on Win (portable), Mac, Linux
  - Does NOT work on Android/iOS

## Key Constraints

### ExFAT Filesystem Rules
- NO symlinks (ExFAT doesn't support them)
- NO Unix permissions (ExFAT ignores chmod)
- NO journaling — always remind users to safely eject
- Max filename: 255 chars, max path: 32,767 chars
- Case-preserving but case-insensitive

### Script Rules
- Windows scripts: .bat format, use `%~dp0` and `%~d0` for paths
- macOS scripts: .command format (double-clickable), use `$(dirname "$0")` for paths
- All .command/.sh files need Unix line endings (LF, not CRLF)
- llamafile binary: `llamafile.exe` on Windows, `llamafile` (no extension) on Mac/Linux
- The `-ngl 999` flag is CRITICAL for macOS — enables Metal GPU acceleration
- The `.portable` file in kiwix app folder enables portable mode (empty file)
- All scripts must be bilingual (Romanian + English) in echo messages

### Windows-Specific
- llamafile on Windows cannot exceed 4GB as single .exe — use engine + external GGUF approach
- Windows SmartScreen will block unsigned executables — scripts must handle this
- Use `wmic computersystem get totalphysicalmemory` for RAM detection

### macOS-Specific
- Gatekeeper blocks unsigned binaries: `xattr -dr com.apple.quarantine` required
- Three methods to unblock: xattr command, System Preferences > Security, right-click > Open
- Kiwix macOS cannot run portably — must install from App Store, but reads ZIM from USB

### Android-Specific
- llamafile does NOT run on Android
- Best beginner option: PocketPal AI or ChatterUI (free apps, load GGUF from storage)
- KoboldCpp available via Termux auto-installer (advanced users)
- Kiwix Android (FULL APK, not Play Store) reads ZIM from USB-OTG (v3.8+)
- Include APKs on the SSD for sideloading

### iOS-Specific
- Most restricted platform — models cannot stream from external USB
- PocketPal AI, LLM Farm, LM Studio can load GGUF but user must copy to device first
- Kiwix iOS: copy ZIM to device via Files app
- Realistic workflow: connect SSD, copy 2.5GB model via Files, load in app
- Include mobile/ folder with smaller quants (Q3_K_M) for storage-limited devices

## Storage Budget (1TB = ~931 GiB usable)

| Tier | Content | Size |
|------|---------|------|
| Core AI engines | llamafile + KoboldCpp (all platforms) | ~1 GB |
| Primary models | Qwen3 4B/8B/14B + Gemma 4B/12B + Whisper | ~29 GB |
| Mobile models | Q3_K_M smaller quants for phones | ~4 GB |
| Knowledge bases | Wikipedia EN maxi (115 GB) + nopic (48 GB) + RO (10.6 GB) + WikiMed + iFixit + StackExchange + more | ~200 GB |
| Apps | Kiwix (all platforms) + VeraCrypt + Android APKs | ~1 GB |
| Encrypted vault | vault.hc VeraCrypt container | ~200 GB |
| **Total used** | | **~435 GB** |
| **Free space** | For user data, future models, more ZIMs | **~496 GB** |

## Project Structure

```
RED-ALERT-LLM/                          (SSD root)
├── START-HERE.html                      # Self-contained HTML launcher, detects OS
├── README.md                            # Bilingual EN/RO comprehensive guide
├── LICENSE                              # MIT
├── CLAUDE.md                            # This file
├── TECH.md                              # Technical architecture document
├── .gitignore
│
├── engines/
│   ├── llamafile/
│   │   ├── llamafile-windows.exe
│   │   ├── llamafile-macos
│   │   └── llamafile-linux
│   ├── koboldcpp/
│   │   ├── koboldcpp-nocuda.exe         # Windows
│   │   ├── koboldcpp-mac-arm64          # macOS Apple Silicon
│   │   └── koboldcpp-linux-x64-nocuda   # Linux
│   └── whisperfile/
│       └── whisperfile                  # Speech-to-text engine
│
├── models/
│   ├── primary/
│   │   ├── qwen3-4b-q4_k_m.gguf        # 2.5 GB — 8GB RAM
│   │   ├── qwen3-8b-q4_k_m.gguf        # 5 GB — 12GB RAM
│   │   └── qwen3-14b-q4_k_m.gguf       # 9 GB — 16GB+ RAM
│   ├── alternatives/
│   │   ├── gemma-3-4b-it-q4_k_m.gguf
│   │   └── gemma-3-12b-it-q4_k_m.gguf
│   ├── specialized/
│   │   └── whisper-large-v3.gguf        # Speech-to-text
│   └── mobile/                          # Smaller quants for phones
│       ├── qwen3-4b-q3_k_m.gguf        # ~2 GB
│       └── gemma-3-4b-q3_k_m.gguf      # ~2 GB
│
├── knowledge/
│   ├── wikipedia_en_all_maxi.zim        # ~115 GB
│   ├── wikipedia_en_all_nopic.zim       # ~48 GB (text-only fallback)
│   ├── wikipedia_ro_all_maxi.zim        # ~10.6 GB
│   ├── wikipedia_ro_all_nopic.zim       # ~2.3 GB
│   ├── mdwiki_en_all.zim               # Medical encyclopedia
│   ├── ifixit_en_all.zim               # Repair guides ~3.3 GB
│   ├── wiktionary_en_all.zim           # Dictionary ~8.2 GB
│   ├── wikivoyage_en_all.zim           # Travel ~1 GB
│   └── stackexchange/                   # Selected sites
│       ├── superuser.com.zim
│       ├── diy.stackexchange.com.zim
│       └── electronics.stackexchange.com.zim
│
├── apps/
│   ├── kiwix/
│   │   ├── kiwix-windows/               # Portable Kiwix Desktop
│   │   │   └── .portable               # Empty file = portable mode
│   │   ├── kiwix-macos.dmg
│   │   ├── kiwix-linux.appimage
│   │   └── kiwix-android-full.apk      # Full version, NOT Play Store
│   ├── veracrypt/
│   │   ├── veracrypt-portable-windows/
│   │   ├── veracrypt-macos.dmg
│   │   └── veracrypt-linux.tar.bz2
│   └── android/
│       ├── pocketpal-ai.apk
│       └── chatterui.apk
│
├── setup/
│   ├── setup-windows.bat                # Calls PowerShell script
│   ├── setup-windows.ps1                # Downloads all components
│   ├── setup-mac.sh                     # macOS setup
│   ├── setup-linux.sh                   # Linux setup
│   └── download-knowledge.sh            # Interactive ZIM downloader
│
├── launchers/
│   ├── start-windows.bat                # Auto-detects RAM, picks model
│   ├── start-macos.command              # macOS launcher
│   ├── start-linux.sh                   # Linux launcher
│   ├── start-kobold-windows.bat
│   ├── start-kobold-macos.command
│   ├── start-kiwix-windows.bat
│   ├── start-kiwix-macos.command
│   └── start-kiwix-linux.sh
│
├── tools/
│   ├── verify-setup.bat                 # Windows verification
│   ├── verify-setup.sh                  # Mac/Linux verification
│   └── create-vault.bat                 # Creates VeraCrypt container
│
├── vault.hc                             # 200 GB VeraCrypt encrypted container
│
├── docs/
│   ├── GHID-COMPLET-RO.md              # Full Romanian guide
│   ├── HARDWARE-GUIDE.md               # Recommended SSDs (eMAG.ro)
│   ├── TROUBLESHOOTING.md              # Bilingual EN/RO
│   ├── PERFORMANCE.md                  # Benchmarks
│   ├── guide-android.md                # Android USB-OTG workflow
│   ├── guide-ios.md                    # iOS limitations & workflow
│   └── guide-vault.md                  # VeraCrypt tutorial
│
└── config/
    ├── models.json                      # Model registry with URLs, sizes, RAM reqs
    └── knowledge.json                   # ZIM registry with URLs, sizes, descriptions
```

## Platform Compatibility Matrix

| Feature | Windows | macOS | Linux | Android | iOS |
|---------|---------|-------|-------|---------|-----|
| llamafile | Yes | Yes (Metal) | Yes | No | No |
| KoboldCpp | Yes | Yes (Metal) | Yes | Termux | No |
| PocketPal AI | No | No | No | Yes | Yes |
| Kiwix | Portable | App Store | AppImage | APK (full) | App Store |
| VeraCrypt vault | Portable | Install | Install | No | No |
| Auto RAM detection | Yes | Yes | Yes | N/A | N/A |
| Zero-install | Yes | Mostly* | Yes | Needs APK | Needs app |

*macOS: Kiwix must be installed from App Store; Gatekeeper must be bypassed for unsigned binaries.

## Launcher Logic (RAM Auto-Detection)

```
IF RAM >= 16 GB → recommend Qwen3-14B (9 GB model)
IF RAM >= 12 GB → recommend Qwen3-8B (5 GB model)
IF RAM >= 8 GB  → recommend Qwen3-4B (2.5 GB model)
IF RAM < 8 GB   → warn user, offer Gemma-3-4B as lighter option
```

## Download URLs (Verified March 2026)

### Engines
- llamafile 0.10.0: https://github.com/mozilla-ai/llamafile/releases/download/0.10.0/llamafile-0.10.0
- llamafile 0.10.0 ZIP: https://github.com/mozilla-ai/llamafile/releases/download/0.10.0/llamafile-0.10.0.zip
- KoboldCpp Win: https://github.com/LostRuins/koboldcpp/releases/download/v1.110/koboldcpp-nocuda.exe
- KoboldCpp macOS: https://github.com/LostRuins/koboldcpp/releases/download/v1.110/koboldcpp-mac-arm64
- KoboldCpp Linux: https://github.com/LostRuins/koboldcpp/releases/download/v1.110/koboldcpp-linux-x64-nocuda
- whisperfile: https://github.com/mozilla-ai/llamafile/releases/download/0.10.0/whisperfile-0.10.0

### Models (HuggingFace) — use bartowski quantizations (official Qwen repo uses different naming)
- Qwen3-4B Q4_K_M: https://huggingface.co/bartowski/Qwen_Qwen3-4B-GGUF/resolve/main/Qwen_Qwen3-4B-Q4_K_M.gguf
- Qwen3-4B Q3_K_M (mobile): https://huggingface.co/bartowski/Qwen_Qwen3-4B-GGUF/resolve/main/Qwen_Qwen3-4B-Q3_K_M.gguf
- Qwen3-8B Q4_K_M: https://huggingface.co/bartowski/Qwen_Qwen3-8B-GGUF/resolve/main/Qwen_Qwen3-8B-Q4_K_M.gguf
- Qwen3-14B Q4_K_M: https://huggingface.co/bartowski/Qwen_Qwen3-14B-GGUF/resolve/main/Qwen_Qwen3-14B-Q4_K_M.gguf
- Gemma-3-4B-IT Q4_K_M: https://huggingface.co/ggml-org/gemma-3-4b-it-GGUF/resolve/main/gemma-3-4b-it-Q4_K_M.gguf
- Whisper large-v3: https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3.bin
- NOTE: We download with -o to our lowercase filenames (qwen3-4b-q4_k_m.gguf etc.) for consistency

### Knowledge (Kiwix ZIM)
- All ZIMs: https://download.kiwix.org/zim/
- Wikipedia EN maxi: https://download.kiwix.org/zim/wikipedia/ (look for wikipedia_en_all_maxi_*)
- Wikipedia RO: https://download.kiwix.org/zim/wikipedia/ (look for wikipedia_ro_all_maxi_*)

### Apps
- Kiwix all platforms: https://kiwix.org/en/applications/
- Kiwix Android FULL APK: https://github.com/kiwix/kiwix-android/releases
- PocketPal AI Android: https://play.google.com/store/apps/details?id=com.pocketpalai
- PocketPal AI iOS: https://apps.apple.com/us/app/pocketpal-ai/id6502579498
- VeraCrypt: https://www.veracrypt.fr/en/Downloads.html

## Implementation Phases

### Phase 0: Repository Setup — DONE (2026-03-24)
- Created 33 files: folder structure, README.md, LICENSE, .gitignore, .gitattributes
- Config JSONs (models.json, knowledge.json with 3 install profiles)
- All setup scripts (Windows .bat/.ps1, macOS .sh, Linux .sh)
- All launcher scripts with RAM auto-detection and GPU detection
- All docs (bilingual README, GHID-COMPLET-RO, TROUBLESHOOTING, PERFORMANCE, HARDWARE-GUIDE, guides for Android/iOS/vault)
- START-HERE.html (self-contained, OS detection, bilingual, tabbed interface)
- Verification tools (verify-setup.bat/.sh, create-vault.bat)
- Git init with .gitattributes (LF for .sh/.command, CRLF for .bat)

### Phase 1: Download Engines & Models — DONE (2026-03-24)
Engines downloaded (2.4 GB total):
- llamafile v0.10.0 (722 MB x3 platforms — APE binary, same file works on Win/Mac/Linux)
- KoboldCpp v1.110: Windows nocuda (93 MB), macOS ARM64 (45 MB), Linux nocuda (110 MB)
- whisperfile v0.10.0 (5.2 MB)

Models downloaded (20 GB total, all verified complete):
- qwen3-4b-q4_k_m.gguf — 2,497,280,960 bytes (VERIFIED: exact match with HuggingFace)
- qwen3-8b-q4_k_m.gguf — 5,027,784,224 bytes
- qwen3-14b-q4_k_m.gguf — 9,001,753,632 bytes
- gemma-3-4b-it-q4_k_m.gguf — 2,489,757,856 bytes
- qwen3-4b-q3_k_m.gguf (mobile) — 2,075,618,240 bytes

Live test result (2026-03-24):
- llamafile v0.10.0 + Qwen3-4B on AMD Ryzen 5 7430U (CPU only)
- Health endpoint: {"status":"ok"}
- Qwen3 thinking mode working: reasoning_content shows chain-of-thought
- Speed: ~2.8 tok/s generation (CPU laptop), ~16.7 tok/s prompt processing
- Romanian: correctly identified "Buna ziua" as Romanian greeting

URL corrections applied:
- Official Qwen repo URLs work: https://huggingface.co/Qwen/Qwen3-4B-GGUF/resolve/main/Qwen3-4B-Q4_K_M.gguf
- Bartowski also works: https://huggingface.co/bartowski/Qwen_Qwen3-4B-GGUF/resolve/main/Qwen_Qwen3-4B-Q4_K_M.gguf
- Scripts use bartowski URLs (verified working with 302 redirects)
- All configs, setup scripts, and CLAUDE.md updated with correct URLs

### Phase 2: Knowledge Base Downloads — DONE (2026-03-24)
All 9 ZIM files downloaded and byte-verified (82 GB total):

| ZIM File | Exact Bytes | Size |
|----------|-------------|------|
| wikipedia_en_all_nopic_2025-12.zim | 51,189,645,349 | 47.7 GB |
| wikipedia_ro_all_maxi_2026-02.zim | 11,426,309,583 | 10.6 GB |
| wikipedia_ro_all_nopic_2026-02.zim | 2,510,298,566 | 2.3 GB |
| wiktionary_en_all_nopic_2026-02.zim | 8,802,883,343 | 8.2 GB |
| superuser.com_en_all_2026-02.zim | 3,999,536,360 | 3.7 GB |
| ifixit_en_all_2025-12.zim | 3,570,695,757 | 3.3 GB |
| mdwiki_en_all_maxi_2025-11.zim | 2,302,838,768 | 2.1 GB |
| diy.stackexchange.com_en_all_2026-02.zim | 2,050,957,131 | 1.9 GB |
| wikivoyage_en_all_maxi_2026-03.zim | 1,125,994,770 | 1.0 GB |

Verified filenames (from kiwix.org directory listings):
- Wiktionary uses "nopic" not "maxi" variant
- WikiMed date is 2025-11 (not 2025-12)
- iFixit date is 2025-12 (not 2026-03)
- Wikivoyage date is 2026-03

NOT downloaded (optional, can add later):
- wikipedia_en_all_maxi_2026-02.zim — 115.5 GB (full EN Wikipedia with images)
- electronics.stackexchange.com_en_all_2026-02.zim — 3.9 GB
- wikibooks_en_all_maxi_2026-02.zim — ~2 GB

download-knowledge.sh script updated with all verified URLs and sizes.

### Phase 3: GitHub Repo & Final Testing — DONE (2026-03-24)
- GitHub repo: https://github.com/gabrielursan-beep/red-alert-llm
- Fixed all .bat files: removed Unicode box-drawing chars (cause CMD errors), removed chcp 65001
- verify-setup.bat tested: 11 PASS / 0 FAIL / 2 WARN (Kiwix desktop = manual download)
- llamafile live test passed: health OK, Qwen3-4B thinking mode working, Romanian output correct
- All 33 files committed and pushed (4,533 lines)
- Binary files (.gguf, .zim, .exe, engines) correctly excluded by .gitignore

### Final Production Audit — DONE (2026-03-24)
- Second full audit: fixed all remaining size inconsistencies across 6 files
- Wikipedia RO nopic: 3.4→2.3 GB, RO maxi: 13→10.6 GB, Wiktionary: 6→8.2 GB, WikiMed: 2→2.1 GB
- Fixed README FAQ about LAN sharing (requires manual --host change)
- Created MANUAL-URGENTA-RO.html — 4-page A4 printable emergency manual in Romanian
- All data verified against actual downloaded bytes — zero discrepancies remain

### Optional: Still Available to Download
- wikipedia_en_all_maxi_2026-02.zim — 115.5 GB (full EN Wikipedia with images)
- electronics.stackexchange.com_en_all_2026-02.zim — 3.9 GB
- wikibooks_en_all_maxi_2026-02.zim — ~2 GB

## Testing Checklist
- [ ] Windows: double-click start-windows.bat → LLM loads → browser opens → chat works
- [ ] macOS: double-click start-macos.command → xattr handled → LLM loads → chat works
- [ ] Windows: Kiwix opens and finds ZIM files automatically
- [ ] Android: copy model to phone → PocketPal loads it → chat works
- [ ] Android: Kiwix APK reads ZIM from USB-OTG
- [ ] Verify all scripts handle spaces in paths
- [ ] Verify ExFAT compatibility (no symlinks used anywhere)
- [ ] Verify .command files have LF line endings
