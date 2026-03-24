# Red Alert LLM — Technical Architecture Document

## 1. System Overview

Red Alert LLM is a portable, zero-install AI toolkit that runs entirely from a USB SSD. It provides:

1. **Local LLM inference** — chat with an AI assistant offline, in any language (119+ supported)
2. **Offline knowledge base** — Wikipedia, medical encyclopedia, repair guides, and more
3. **Encrypted personal vault** — 200 GB VeraCrypt container for sensitive documents
4. **Cross-platform support** — Windows, macOS, Linux, Android, iOS

Everything runs from the SSD with no software installation required on the host computer (with limited exceptions for mobile platforms).

---

## 2. Hardware Target

### Primary: Kingston XS1000 1TB Dual Portable SSD
- **Model:** SXS1000/1000G (also sold as SPSD-1TB in some markets)
- **Interfaces:** USB-A + USB-C (single cable, dual connector)
- **Speed:** USB 3.2 Gen 2 — up to 1,050 MB/s read, 1,000 MB/s write
- **Dimensions:** 69.54 x 32.58 x 13.5 mm (keychain-sized)
- **Weight:** 28.2g
- **Filesystem:** ExFAT (factory default, cross-platform compatible)
- **Operating temp:** 0°C to 40°C
- **Price:** 743 RON (March 2026)
- **Buy link:** [eMAG.ro](https://bit.ly/4uEu0nA) *(affiliate link — supports the project)*

### Why ExFAT
- Native read/write on Windows, macOS, Linux, Android
- No 4GB file size limit (unlike FAT32)
- No partition scheme conflicts between OS
- **Trade-offs:** No journaling (risk of corruption on unsafe eject), no file permissions, no symlinks

### Alternatives
Any USB 3.0+ SSD or flash drive with 256 GB+ storage will work. Smaller/slower drives are compatible but will have longer model loading times and less space for knowledge bases.

---

## 3. LLM Inference Architecture

### 3.1 llamafile (Primary Engine)

**What it is:** A single executable that bundles llama.cpp + a web server + a chat UI. Created by Mozilla. Uses the APE (Actually Portable Executable) format to run on 6 operating systems from one binary.

**Version:** 0.10.0 (March 19, 2026) — major rewrite with full llama.cpp server compatibility.

**How it works:**
```
User double-clicks launcher script
    → Script detects OS and available RAM
    → Script selects appropriate model file
    → llamafile starts with: llamafile -m <model.gguf> --host 127.0.0.1 --port 8080
    → Web UI available at http://127.0.0.1:8080
    → Browser opens automatically
```

**Architecture:**
```
┌─────────────────────────────────────────────┐
│  Browser (any)                               │
│  http://127.0.0.1:8080                       │
│  ┌─────────────────────────────────────┐     │
│  │  Chat UI (built into llamafile)      │     │
│  │  - Text input                        │     │
│  │  - Streaming responses               │     │
│  │  - Settings (temperature, etc.)      │     │
│  └─────────────────────────────────────┘     │
└──────────────────┬──────────────────────────┘
                   │ HTTP (SSE streaming)
┌──────────────────▼──────────────────────────┐
│  llamafile server                            │
│  ┌──────────────┐  ┌─────────────────────┐  │
│  │  HTTP Server  │  │  llama.cpp engine    │  │
│  │  (OpenAI API  │  │  - GGUF loader       │  │
│  │   compatible) │  │  - KV cache          │  │
│  └──────────────┘  │  - Token sampler      │  │
│                     │  - GPU offloading     │  │
│                     └─────────────────────┘  │
└──────────────────┬──────────────────────────┘
                   │ mmap()
┌──────────────────▼──────────────────────────┐
│  USB SSD (ExFAT)                             │
│  models/primary/qwen3-8b-q4_k_m.gguf        │
└─────────────────────────────────────────────┘
```

**Key flags:**
| Flag | Purpose | When to use |
|------|---------|-------------|
| `-m <path>` | Path to GGUF model | Always |
| `--host 127.0.0.1` | Listen on localhost only (secure) | Always (use 0.0.0.0 only for LAN sharing) |
| `--port 8080` | HTTP port | Always |
| `-c 4096` | Context size (tokens) | Always (increase for longer conversations) |
| `-ngl 999` | GPU layers (offload all to GPU) | macOS Metal, NVIDIA CUDA |
| `-t <N>` | Thread count | Set to CPU core count for best perf |
| `--chat-template` | Override chat template | If model has wrong template |

**GPU acceleration:**
| Platform | GPU API | Flag | Auto-detected? |
|----------|---------|------|----------------|
| macOS Apple Silicon | Metal | `-ngl 999` | Must specify explicitly |
| macOS Intel | None (CPU only) | — | — |
| Windows NVIDIA | CUDA | `-ngl 999` | Yes, if CUDA toolkit installed |
| Windows AMD | Vulkan | `--gpu vulkan` | Experimental |
| Windows Intel | CPU only | — | — |
| Linux NVIDIA | CUDA | `-ngl 999` | Yes |

### 3.2 KoboldCpp (Secondary Engine)

**What it is:** A single-file llama.cpp wrapper with a rich built-in web UI (KoboldAI Lite). Better for creative writing, roleplay, and advanced users.

**Architecture:** Same as llamafile but with additional features:
- Memory system (persistent context injection)
- Author's Note (mid-context injection)
- World Info (triggered context injection)
- Multiple samplers with visual controls
- Story mode + Chat mode + Instruct mode

**When to use KoboldCpp over llamafile:**
- User wants creative writing features
- llamafile has a bug on their specific system
- User wants KoboldAI Lite's more detailed settings UI

### 3.3 Mobile Inference

**Android path:**
```
USB-OTG cable connects SSD to phone
    → User opens file manager, navigates to SSD
    → Copies qwen3-4b-q3_k_m.gguf (~2 GB) to internal storage
    → Opens PocketPal AI / ChatterUI
    → Loads the copied GGUF file
    → Chat works fully offline
```

**iOS path:**
```
USB-C/Lightning connects SSD to iPhone/iPad
    → User opens Files app, navigates to SSD
    → Copies qwen3-4b-q3_k_m.gguf (~2 GB) to "On My iPhone"
    → Opens PocketPal AI / LM Studio
    → Imports the GGUF file
    → Chat works fully offline
```

**Mobile model performance:**
| Device | Model | Speed | Usable? |
|--------|-------|-------|---------|
| iPhone 15 Pro (8 GB) | Qwen3-4B Q4_K_M | ~15-20 tok/s | Yes |
| iPhone 13 (4 GB) | Qwen3-4B Q3_K_M | ~8-12 tok/s | Marginal |
| Samsung S24 (12 GB) | Qwen3-4B Q4_K_M | ~10-15 tok/s | Yes |
| Xiaomi Redmi 14C (4 GB) | Gemma-3-1B Q4_K_M | ~5-8 tok/s | Basic only |
| iPad Air M2 (8 GB) | Qwen3-8B Q4_K_M | ~20-30 tok/s | Excellent |

---

## 4. Knowledge Base Architecture

### 4.1 Kiwix + ZIM Format

**ZIM (Zeno IMproved)** is a compressed archive format designed for offline content. Each .zim file contains an entire website (Wikipedia, StackExchange, etc.) with full-text search, navigation, and images.

**Kiwix** is the reader application that opens ZIM files. Available on every platform.

**Architecture:**
```
┌──────────────────────────────────┐
│  Kiwix Desktop / Kiwix Android   │
│  ┌─────────────┐ ┌────────────┐ │
│  │  ZIM Reader  │ │ Search     │ │
│  │  (xapian     │ │ Engine     │ │
│  │   decompress)│ │ (built-in) │ │
│  └──────┬──────┘ └────────────┘ │
└─────────┼────────────────────────┘
          │ reads
┌─────────▼────────────────────────┐
│  USB SSD                          │
│  knowledge/                       │
│  ├── wikipedia_en_all_maxi.zim    │  115 GB
│  ├── wikipedia_ro_all_maxi.zim    │   10.6 GB
│  ├── mdwiki_en_all.zim            │    2 GB
│  └── ...                          │
└──────────────────────────────────┘
```

**Alternative: kiwix-serve** — a headless server that serves ZIM content over HTTP. Useful for:
- Serving content to multiple devices on a local network
- Accessing Wikipedia from any browser without installing Kiwix
- Running on a Raspberry Pi as a local knowledge server

```bash
# Serve all ZIM files on port 8888
./kiwix-serve --port 8888 knowledge/*.zim
# Then open http://localhost:8888 in any browser
```

### 4.2 Knowledge Base Inventory

| Content | ZIM File | Size | Priority | Description |
|---------|----------|------|----------|-------------|
| Wikipedia EN (full) | wikipedia_en_all_maxi_*.zim | 115 GB | Essential | 6.8M articles with images |
| Wikipedia EN (text) | wikipedia_en_all_nopic_*.zim | 48 GB | Backup | Same articles, no images |
| Wikipedia RO (full) | wikipedia_ro_all_maxi_*.zim | 10.6 GB | Essential | Romanian Wikipedia with images |
| Wikipedia RO (text) | wikipedia_ro_all_nopic_*.zim | 2.3 GB | Backup | For storage-limited devices |
| WikiMed | mdwiki_en_all_maxi_*.zim | 2.1 GB | High | 73,000+ medical articles |
| iFixit EN | ifixit_en_all_*.zim | 3.3 GB | High | Electronics & device repair |
| Wiktionary EN | wiktionary_en_all_nopic_*.zim | 8.2 GB | Medium | Dictionary + etymology |
| Wikivoyage EN | wikivoyage_en_all_maxi_*.zim | 1 GB | Medium | Travel guides worldwide |
| SuperUser | superuser.com_*.zim | 3.7 GB | Medium | Tech support Q&A |
| DIY SE | diy.stackexchange.com_*.zim | 1.9 GB | Medium | Home repair Q&A |
| Electronics SE | electronics.stackexchange.com_*.zim | 3.9 GB | Optional | Electronics Q&A |

**Total knowledge base:** ~200 GB (adjustable based on user needs)

### 4.3 Knowledge + LLM Integration (Future)

A future enhancement could enable RAG (Retrieval-Augmented Generation):
1. User asks LLM a question
2. System searches ZIM files for relevant articles via kiwix-serve API
3. Relevant passages are injected into the LLM's context
4. LLM answers with Wikipedia-grounded information

This requires:
- kiwix-serve running alongside the LLM
- A lightweight orchestrator script (Python or Node.js)
- An embedding model (nomic-embed-text, ~300 MB) for semantic search

Not in v1.0 scope but architecturally possible.

---

## 5. Encrypted Vault Architecture

### 5.1 VeraCrypt Container

**What:** A single file (`vault.hc`, 200 GB) that appears as an encrypted virtual disk when mounted.

**Encryption:** AES-256 + SHA-512 hash. Standard VeraCrypt security.

**Filesystem inside container:** ExFAT (for cross-platform compatibility when mounted).

**How it works:**
```
USB SSD (ExFAT)
├── vault.hc                    ← 200 GB encrypted file
│   ┌─────────────────────────┐
│   │  When mounted, appears   │
│   │  as drive V: (Windows)   │
│   │  or /Volumes/VAULT (Mac) │
│   │                          │
│   │  /documents/             │
│   │  /photos/                │
│   │  /medical-records/       │
│   │  /financial/             │
│   │  /passwords/             │
│   │  /certificates/          │
│   └─────────────────────────┘
└── apps/veracrypt/             ← Portable VeraCrypt (Windows)
```

**Platform support:**
| Platform | VeraCrypt Available | Portable? | Notes |
|----------|--------------------|-----------|-------|
| Windows | Yes | Yes (runs from SSD) | Full support, no install needed |
| macOS | Yes | No (requires install + macFUSE) | One-time setup required |
| Linux | Yes | No (requires install) | Available in most package managers |
| Android | No | — | Use alternative (EDS Lite, experimental) |
| iOS | No | — | No VeraCrypt support at all |

### 5.2 Suggested Vault Structure

```
vault.hc (mounted)
├── documents/
│   ├── personal/              # ID scans, contracts
│   ├── work/                  # Work documents
│   └── legal/                 # Legal documents
├── photos/
│   ├── family/
│   └── important/
├── medical-records/
│   ├── prescriptions/
│   ├── lab-results/
│   └── insurance/
├── financial/
│   ├── tax-returns/
│   ├── investments/
│   └── receipts/
├── passwords/
│   └── passwords.kdbx        # KeePass database
├── certificates/
│   ├── ssl/
│   └── personal/
└── backups/
    ├── phone-backup/
    └── cloud-export/
```

---

## 6. Launcher Script Architecture

### 6.1 RAM Auto-Detection

**Windows (batch):**
```batch
for /f "skip=1" %%i in ('wmic computersystem get totalphysicalmemory') do (
    set /a RAM_GB=%%i / 1073741824
)
```

**macOS (bash):**
```bash
RAM_GB=$(( $(sysctl -n hw.memsize) / 1073741824 ))
```

**Linux (bash):**
```bash
RAM_GB=$(( $(grep MemTotal /proc/meminfo | awk '{print $2}') / 1048576 ))
```

### 6.2 Model Selection Logic

```
function select_model(ram_gb):
    if ram_gb >= 16:
        return "models/primary/qwen3-14b-q4_k_m.gguf"    # 9 GB model
    elif ram_gb >= 12:
        return "models/primary/qwen3-8b-q4_k_m.gguf"     # 5 GB model
    elif ram_gb >= 8:
        return "models/primary/qwen3-4b-q4_k_m.gguf"     # 2.5 GB model
    elif ram_gb >= 6:
        return "models/alternatives/gemma-3-4b-it-q4_k_m.gguf"  # 2.5 GB lighter
    else:
        warn("Insufficient RAM. Minimum 6 GB required.")
        exit(1)
```

### 6.3 GPU Detection

**macOS Apple Silicon detection:**
```bash
if sysctl -n machdep.cpu.brand_string | grep -q "Apple"; then
    GPU_FLAGS="-ngl 999"  # Metal acceleration
else
    GPU_FLAGS=""  # Intel Mac, CPU only
fi
```

**Windows NVIDIA detection:**
```batch
where nvidia-smi >nul 2>&1
if %errorlevel%==0 (
    set GPU_FLAGS=-ngl 999
) else (
    set GPU_FLAGS=
)
```

---

## 7. Performance Benchmarks

### 7.1 LLM Inference Speed (tokens/second)

Measured with Qwen3-4B Q4_K_M, 4096 context, prompt eval + generation:

| Hardware | RAM | GPU | Engine | Speed (tok/s) |
|----------|-----|-----|--------|---------------|
| MacBook Air M1 | 8 GB | Metal | llamafile | 25-35 |
| MacBook Pro M2 | 16 GB | Metal | llamafile | 40-55 |
| MacBook Pro M3 Pro | 36 GB | Metal | llamafile | 50-70 |
| Windows i5-12400 | 16 GB | CPU | llamafile | 10-18 |
| Windows Ryzen 5 5600X | 32 GB | CPU | llamafile | 15-25 |
| Windows + RTX 3060 | 16 GB | CUDA | llamafile | 40-60 |
| Windows + RTX 4070 | 32 GB | CUDA | llamafile | 60-90 |
| iPhone 15 Pro | 8 GB | ANE | PocketPal | 15-20 |
| Samsung S24 Ultra | 12 GB | Adreno | PocketPal | 10-15 |

### 7.2 Model Loading Time from USB SSD

| Model | Size | USB 3.2 Gen 2 (1 GB/s) | USB 3.0 (300 MB/s) |
|-------|------|-------------------------|---------------------|
| Qwen3-4B Q4_K_M | 2.5 GB | ~3 sec | ~9 sec |
| Qwen3-8B Q4_K_M | 5.0 GB | ~5 sec | ~17 sec |
| Qwen3-14B Q4_K_M | 9.0 GB | ~10 sec | ~30 sec |

*After initial load, the model stays in RAM. USB speed only matters for startup.*

### 7.3 What Affects Speed

**Main factor: Memory bandwidth** (not CPU clock speed)

| Factor | Impact | Explanation |
|--------|--------|-------------|
| Memory bandwidth | HIGH | LLM inference is memory-bound. DDR5 > DDR4, unified memory (Apple Silicon) wins |
| GPU offloading | HIGH | Metal/CUDA offloads matrix math to GPU, 2-5x faster than CPU |
| Model quantization | MEDIUM | Q4_K_M is the sweet spot — Q3 is faster but dumber, Q5 is smarter but slower |
| Context size | MEDIUM | Larger context = more memory = slower per-token. 4096 is good default |
| CPU cores | LOW | More cores help with prompt processing, not generation |
| USB speed | NEGLIGIBLE | Only affects initial model load (once), not inference |

---

## 8. Security Considerations

### 8.1 LLM Security
- **All inference is local** — no data leaves the device
- **No telemetry** — llamafile and KoboldCpp do not phone home
- **Network exposure** — launcher scripts bind to 127.0.0.1 (localhost only). To share on LAN, change to 0.0.0.0 manually
- **Model output** — LLMs can hallucinate. Medical/legal information should be cross-referenced with Kiwix knowledge bases

### 8.2 USB SSD Security
- **ExFAT has no encryption** — anyone with physical access can read files
- **VeraCrypt vault** protects sensitive personal data with AES-256
- **Safe eject is CRITICAL** — ExFAT has no journaling, unsafe removal can corrupt files
- **Wear leveling** — SSDs handle this internally, no user action needed

### 8.3 Unsigned Binary Warnings
- **Windows SmartScreen:** will warn about llamafile.exe and koboldcpp.exe (unsigned)
  - Fix: "More info" → "Run anyway"
  - Or: Right-click → Properties → Unblock
- **macOS Gatekeeper:** will block all downloaded binaries
  - Fix: `xattr -dr com.apple.quarantine <path>` (automated in setup script)
  - Or: System Settings → Privacy & Security → "Open Anyway"
- **Android APK sideloading:** requires "Install from unknown sources" permission

---

## 9. File Size & Storage Analysis

### 9.1 Full Installation Breakdown

```
STORAGE BUDGET: 931 GiB (1 TB SSD)
═══════════════════════════════════════════════════════════

AI Engines                                          ~1 GB
├── llamafile (Win/Mac/Linux)                     721 MB
├── KoboldCpp (Win/Mac/Linux)                     245 MB
├── whisperfile                                      5 MB
└── kiwix-serve (Win/Mac/Linux)                    30 MB

AI Models                                         ~33 GB
├── Qwen3-4B Q4_K_M                              2.5 GB
├── Qwen3-8B Q4_K_M                              5.0 GB
├── Qwen3-14B Q4_K_M                             9.0 GB
├── Gemma-3-4B-IT Q4_K_M                         2.5 GB
├── Gemma-3-12B-IT Q4_K_M                        7.0 GB
├── Whisper-large-v3                              3.0 GB
├── Qwen3-4B Q3_K_M (mobile)                     2.0 GB
└── Gemma-3-4B Q3_K_M (mobile)                   2.0 GB

Knowledge Bases                                  ~200 GB
├── Wikipedia EN (full with images)             115.0 GB
├── Wikipedia EN (text only, backup)             48.0 GB
├── Wikipedia RO (full)                          10.6 GB
├── Wikipedia RO (text only, for mobile)          2.3 GB
├── WikiMed medical encyclopedia                  2.0 GB
├── iFixit repair guides                          3.3 GB
├── Wiktionary EN                                 8.2 GB
├── Wikivoyage EN                                 1.0 GB
├── SuperUser Q&A                                 3.7 GB
├── DIY StackExchange                             1.9 GB
└── Electronics StackExchange                     3.9 GB

Applications                                      ~1 GB
├── Kiwix Desktop (Win portable)                200 MB
├── Kiwix macOS DMG                             100 MB
├── Kiwix Linux AppImage                        100 MB
├── Kiwix Android APK (full)                     50 MB
├── VeraCrypt Portable (Win)                     30 MB
├── VeraCrypt macOS DMG                          30 MB
├── PocketPal AI APK                             50 MB
└── ChatterUI APK                                50 MB

Encrypted Vault                                 ~200 GB
└── vault.hc (VeraCrypt container)              200 GB

Project Files (scripts, docs, configs)            ~5 MB
├── Launchers, setup scripts                      1 MB
├── Documentation (markdown)                      2 MB
├── Config JSONs                                  1 MB
└── START-HERE.html                               1 MB

═══════════════════════════════════════════════════════════
TOTAL USED:                                     ~435 GB
FREE SPACE:                                     ~496 GB
═══════════════════════════════════════════════════════════
```

### 9.2 Minimal Installation (256 GB drive)

For users with smaller drives, a minimal setup:

```
MINIMAL BUDGET: 238 GiB (256 GB drive)
═══════════════════════════════════════
AI Engine: llamafile only                      721 MB
Model: Qwen3-4B only                          2.5 GB
Knowledge: Wikipedia EN nopic + RO nopic      51.4 GB
Vault: None (or 50 GB)                       0-50 GB
═══════════════════════════════════════
TOTAL: 55-105 GB (plenty of room)
```

---

## 10. Network Topology (Local Mode)

When running on a laptop connected to the USB SSD:

```
┌─────────────────────────────────────────────────────┐
│  Host Computer                                       │
│                                                      │
│  ┌────────────┐     ┌──────────────┐                │
│  │  Browser    │◄───►│  llamafile   │  :8080         │
│  │  (Chat UI)  │     │  server      │                │
│  └────────────┘     └──────┬───────┘                │
│                            │ mmap                    │
│  ┌────────────┐     ┌──────▼───────┐                │
│  │  Browser    │◄───►│  kiwix-serve │  :8888         │
│  │  (Wikipedia)│     │  server      │                │
│  └────────────┘     └──────┬───────┘                │
│                            │ read                    │
└────────────────────────────┼────────────────────────┘
                             │ USB 3.2
┌────────────────────────────▼────────────────────────┐
│  Kingston 1TB SSD (ExFAT)                            │
│  ├── engines/llamafile/                              │
│  ├── models/primary/*.gguf                           │
│  └── knowledge/*.zim                                 │
└─────────────────────────────────────────────────────┘
```

### Optional: LAN Sharing Mode

If the user wants to share the AI + Wikipedia with other devices on the same WiFi:

```
         WiFi / Ethernet LAN
    ┌──────────┬───────────┬──────────┐
    │          │           │          │
┌───▼──┐  ┌───▼──┐  ┌────▼───┐  ┌──▼───┐
│Phone │  │Tablet│  │Laptop2 │  │ Host │
│      │  │      │  │        │  │ + SSD│
└──────┘  └──────┘  └────────┘  └──────┘
                                  │
                         llamafile :8080
                         kiwix-serve :8888
```

To enable: change `--host 127.0.0.1` to `--host 0.0.0.0` in the launcher script. Then other devices on the same network can access `http://<host-ip>:8080` for AI chat and `http://<host-ip>:8888` for Wikipedia.

---

## 11. Model Comparison & Selection Guide

### 11.1 Why Qwen3 as Primary

| Criteria | Qwen3 | Gemma 3 | Llama 3.2 | Phi-4 |
|----------|-------|---------|-----------|-------|
| Romanian support | Excellent (119 langs) | Good (140+ langs) | Limited | Poor (~20 langs) |
| Reasoning quality | Best-in-class for size | Good | Good | Best math |
| Code generation | Strong | Moderate | Strong | Strong |
| Chat quality | Excellent | Good | Good | Good |
| "Thinking" mode | Yes (dual mode) | No | No | No |
| License | Apache 2.0 | Apache 2.0 | Llama 3.2 | MIT |

**Qwen3's "thinking mode"** is unique: the model can optionally show its reasoning process (chain-of-thought) before giving an answer. This significantly improves accuracy for complex questions. Users can toggle it on/off.

### 11.2 Quantization Guide

| Quantization | Size vs Full | Quality Loss | Speed | Recommended For |
|-------------|-------------|-------------|-------|-----------------|
| Q2_K | 29% | Significant | Fastest | Don't use, too much quality loss |
| Q3_K_M | 37% | Moderate | Fast | Mobile devices with limited storage |
| **Q4_K_M** | **47%** | **Minimal** | **Balanced** | **Default for all desktop use** |
| Q5_K_M | 55% | Very small | Slower | When quality matters more than speed |
| Q6_K | 64% | Negligible | Slow | Maximum quality, lots of RAM |
| Q8_0 | 84% | None | Slowest | Benchmarking, not for daily use |

---

## 12. Future Enhancements (v2.0 Roadmap)

### 12.1 RAG Integration
- Connect LLM to Kiwix knowledge base via kiwix-serve API
- User asks question → system searches Wikipedia → injects context → LLM answers with sources
- Requires: orchestrator script, embedding model, kiwix-serve

### 12.2 Voice Interface
- Whisper (via whisperfile) for speech-to-text input
- User speaks → transcribed to text → fed to LLM → response displayed
- Requires: whisperfile running alongside llamafile, browser microphone API

### 12.3 Document QA
- Upload PDFs/documents to the LLM for analysis
- llamafile 0.10.0 supports file upload via web UI
- Could integrate with VeraCrypt vault for private document analysis

### 12.4 Offline Maps
- OpenStreetMap ZIM files available via Kiwix (~80 GB for world)
- Combined with Wikivoyage for travel-ready offline kit

### 12.5 Multi-User Mode
- kiwix-serve + llamafile on shared network
- Simple auth layer (basic HTTP auth via reverse proxy)
- Useful for classroom/family scenarios

---

## 13. Dependency Matrix

| Component | Depends On | Notes |
|-----------|-----------|-------|
| llamafile | Nothing | Self-contained binary |
| KoboldCpp | Nothing | Self-contained binary |
| Kiwix Desktop (Win) | .portable file | Must be in same dir as exe |
| Kiwix Desktop (Mac) | App Store install | Cannot run portably |
| Kiwix Android | Sideload permission | Use full APK, not Play Store |
| PocketPal AI | Play Store / App Store | Model must be copied to device |
| VeraCrypt (Win) | Nothing | Portable version runs from SSD |
| VeraCrypt (Mac) | macFUSE | One-time system install |
| ZIM files | Kiwix or kiwix-serve | Just data files |
| GGUF models | llamafile or KoboldCpp | Just data files |
| setup scripts | curl, PowerShell | Pre-installed on modern OS |

**Zero external dependencies for core functionality on Windows.** macOS requires Gatekeeper bypass (automated). Mobile requires app installation.

---

## 14. Glossary

| Term | Definition |
|------|-----------|
| **GGUF** | GPT-Generated Unified Format — standard format for quantized LLM models |
| **ZIM** | Zeno IMproved — compressed archive format for offline web content |
| **llamafile** | Mozilla's portable LLM inference engine (single binary, 6 OS) |
| **KoboldCpp** | Alternative LLM inference engine with rich creative writing UI |
| **Kiwix** | Reader application for ZIM files (offline Wikipedia, etc.) |
| **Metal** | Apple's GPU API — used for LLM acceleration on M1/M2/M3/M4 chips |
| **CUDA** | NVIDIA's GPU API — used for LLM acceleration on NVIDIA GPUs |
| **ExFAT** | Extended FAT filesystem — cross-platform, no 4GB limit, no journaling |
| **VeraCrypt** | Open-source disk encryption — creates encrypted container files |
| **Q4_K_M** | 4-bit quantization (medium) — best balance of size/quality for GGUF |
| **RAG** | Retrieval-Augmented Generation — LLM + search for grounded answers |
| **APE** | Actually Portable Executable — Cosmopolitan Libc format, runs on 6 OS |
| **tok/s** | Tokens per second — speed metric for LLM text generation |
| **ngl** | Number of GPU Layers — how much of the model is offloaded to GPU |
| **OTG** | On-The-Go — USB standard that lets phones act as USB hosts |
