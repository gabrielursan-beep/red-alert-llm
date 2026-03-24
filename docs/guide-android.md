# Android Guide / Ghid Android

## Requirements / Cerinte
- Android 8.0+ phone or tablet
- 6+ GB RAM (4 GB minimum, slow)
- USB-C port with OTG support (or micro-USB + OTG adapter)
- 3+ GB free internal storage

## Step 1: Connect SSD / Conectati SSD-ul

1. Connect the Kingston SSD to your phone via USB-C
   - The SSD's USB-C connector plugs directly into modern Android phones
   - For older phones with micro-USB: use a micro-USB OTG adapter (~15 RON)
2. Your phone should show a notification "USB drive connected"
3. Open your file manager to verify you can see the SSD contents

## Step 2: Install AI App / Instalati aplicatia AI

**Option A: PocketPal AI (recommended)**
- Install from Google Play Store: search "PocketPal AI"
- Or sideload from SSD: navigate to `apps/android/pocketpal-ai.apk`

**Option B: ChatterUI**
- Sideload from SSD: `apps/android/chatterui.apk`
- You may need to enable "Install from unknown sources" in Settings

## Step 3: Copy Model to Phone / Copiati modelul pe telefon

The AI model must be on your phone's internal storage (not on the SSD).

1. Open your file manager
2. Navigate to the SSD → `models/mobile/`
3. Copy `qwen3-4b-q3_k_m.gguf` (~2 GB) to your phone's internal storage
   - Suggested location: `Internal Storage/Download/` or `Internal Storage/Models/`
4. Wait for the copy to complete (~2-3 minutes)

## Step 4: Load Model / Incarcati modelul

**PocketPal AI:**
1. Open the app
2. Tap the model selector
3. Choose "Import Model" or browse to the copied .gguf file
4. Wait for loading (30-60 seconds)
5. Start chatting!

**ChatterUI:**
1. Open the app → Settings → Models
2. Add the path to your copied .gguf file
3. Select the model and start chatting

## Step 5: Install Kiwix for Wikipedia / Instalati Kiwix pentru Wikipedia

**Important:** Use the FULL Kiwix APK, NOT the Play Store version.

The Play Store version has Android 11+ storage restrictions that prevent reading ZIM files from USB drives.

1. Navigate to SSD → `apps/android/kiwix-android-full.apk`
2. Tap to install (enable "Unknown sources" if prompted)
3. Open Kiwix
4. The app should detect ZIM files on the USB SSD automatically
5. If not: tap the library icon → "Get from storage" → navigate to SSD → `knowledge/`

## Tips / Sfaturi

- **Battery drain:** Running an AI model uses significant CPU/GPU. Plug your phone into a charger.
- **Phone gets hot:** Normal during AI inference. Take breaks if it gets too hot.
- **Speed:** Expect 5-15 tokens/second on most modern phones. Older phones will be slower.
- **RAM issues:** If the app crashes, your phone doesn't have enough RAM. Try closing all other apps.
- **Smaller ZIM for phone:** If you want Wikipedia on your phone (not from SSD), copy `wikipedia_ro_all_nopic_*.zim` (~2.3 GB) — it's small enough for most phones.

## Troubleshooting / Rezolvarea problemelor

**Phone doesn't see the SSD:**
- Not all phones support USB-OTG. Check your phone's specifications.
- Try a different cable
- Try a powered USB hub
- Check Settings → Storage → look for external storage

**"Install from unknown sources" not available:**
- Settings → Apps → Special app access → Install unknown apps → Your file manager → Allow

**App crashes when loading model:**
- Not enough RAM. Close all other apps and try again.
- If still crashing, your phone may not have enough RAM for this model.
- Try an even smaller model if available.
