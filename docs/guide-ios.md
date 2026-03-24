# iOS Guide / Ghid iOS

## Requirements / Cerinte
- iPhone or iPad with 6+ GB RAM (8+ GB recommended)
- USB-C port (iPhone 15+) or Lightning with USB Camera Adapter
- iOS 16+
- 3+ GB free storage on device

## Limitations / Limitari

iOS is the most restricted platform for this project:
- Models CANNOT stream directly from the SSD — they must be copied to device storage
- VeraCrypt vault is NOT accessible on iOS
- Kiwix works but ZIM files should be copied to device for best results
- Overall workflow requires more manual steps than other platforms

## Recommended Devices

| Device | RAM | Experience |
|--------|-----|-----------|
| iPhone 15 Pro / Pro Max | 8 GB | Excellent |
| iPhone 16 | 8 GB | Excellent |
| iPad Air M2 | 8 GB | Best (larger screen) |
| iPad Pro M3/M4 | 8-16 GB | Best |
| iPhone 14 Pro | 6 GB | Good |
| iPhone 13 | 4 GB | Marginal (may be too slow) |

## Step 1: Connect SSD / Conectati SSD-ul

**USB-C iPhones (15+):**
- Connect the Kingston SSD directly via USB-C

**Lightning iPhones (14 and older):**
- Use Apple Lightning to USB Camera Adapter (~150 RON)
- Or third-party Lightning OTG adapter (~50 RON)
- Connect the SSD's USB-A end to the adapter

## Step 2: Install AI App / Instalati aplicatia AI

Install one of these from the App Store:

- **PocketPal AI** (recommended) — free, loads GGUF models, HuggingFace integration
- **LM Studio** — polished UI, supports both GGUF and MLX formats
- **LLM Farm** — open-source, loads GGUF via llama.cpp

## Step 3: Copy Model to iPhone / Copiati modelul pe iPhone

1. Open the **Files** app
2. Under "Locations", find the external SSD
3. Navigate to `models/mobile/`
4. Long-press on `qwen3-4b-q3_k_m.gguf` → Copy
5. Navigate to "On My iPhone" → create a "Models" folder
6. Paste the file (~2 GB, takes 2-3 minutes)

## Step 4: Load Model in App / Incarcati modelul in aplicatie

**PocketPal AI:**
1. Open the app
2. Tap "Add Model" or the model selector
3. Choose "Import from Files"
4. Navigate to On My iPhone → Models → select the .gguf file
5. Wait for loading (~30-60 seconds)
6. Start chatting!

**LM Studio:**
1. Open the app
2. Search for the model or tap "Import"
3. Select the .gguf file from Files
4. Load and start chatting

## Step 5: Wikipedia with Kiwix / Wikipedia cu Kiwix

1. Install **Kiwix** from the App Store (free)
2. For best results, copy a ZIM file to your device:
   - Files app → SSD → knowledge/ → long-press a .zim file → Copy
   - Navigate to On My iPhone → Paste
   - Recommended: `wikipedia_ro_all_nopic_*.zim` (~2.3 GB)
3. Open Kiwix → Library → "Open file" → select the .zim file

**Note:** Large ZIM files (Wikipedia EN at 48-115 GB) won't fit on most iPhones. Use the Romanian text-only version or WikiMed.

## Tips / Sfaturi

- **Storage:** iPhone storage fills up fast. The 2 GB model + 2.3 GB Romanian Wikipedia = ~4.3 GB needed.
- **Battery:** AI inference drains battery quickly. Keep your iPhone charged.
- **Heat:** Normal for the phone to get warm during AI use.
- **Speed:** iPhone 15 Pro gets ~15-20 tok/s. Older iPhones will be slower.
- **Delete after use:** If you need to free space, delete the model from Files when done. You can always re-copy from the SSD.

## Troubleshooting

**SSD not showing in Files app:**
- Make sure the SSD is ExFAT formatted
- Try disconnecting and reconnecting
- Check if the adapter/cable supports data transfer (not just charging)

**Copy fails or is very slow:**
- iOS may throttle USB transfers in the background
- Keep the Files app open and the screen on during copy
- Try copying via a Mac (AirDrop to iPhone) as an alternative

**App crashes:**
- iPhone doesn't have enough RAM. Close all other apps.
- Try force-closing background apps (swipe up from bottom, swipe away apps)
- iPhone 13 and older (4 GB RAM) may struggle with 4B models
