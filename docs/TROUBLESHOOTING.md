# Troubleshooting / Rezolvarea Problemelor

## Windows SmartScreen blocks the .exe / SmartScreen blocheaza executabilul

**Problem:** "Windows protected your PC" message when running llamafile or KoboldCpp.

**Solution:**
1. Click "More info"
2. Click "Run anyway"

**Alternative:** Right-click the .exe → Properties → Check "Unblock" → Apply

---

## macOS Gatekeeper blocks the binary / Gatekeeper blocheaza programul

**Problem:** "cannot be opened because the developer cannot be verified"

**Solution 1 (recommended):**
```bash
xattr -dr com.apple.quarantine /path/to/red-alert-llm/engines/
```

**Solution 2:**
Right-click the file → "Open" → "Open" (in the dialog)

**Solution 3:**
System Settings → Privacy & Security → Scroll down → Click "Open Anyway"

---

## "Model loads but responses are very slow" / "Modelul se incarca dar raspunsurile sunt foarte lente"

**Cause:** Not enough RAM. The model is swapping to disk.

**Solution:**
- Use a smaller model (4B instead of 8B or 14B)
- Close other applications to free RAM
- On macOS Apple Silicon, make sure `-ngl 999` is being used (Metal GPU)
- On Windows with NVIDIA GPU, make sure CUDA is being used

**Expected speed on CPU only:** 5-18 tokens/sec (this is normal for CPU)

---

## "Permission denied" on macOS / "Permisiune refuzata" pe macOS

**Problem:** Cannot execute llamafile or KoboldCpp.

**Solution:**
```bash
chmod +x engines/llamafile/llamafile-macos
chmod +x engines/koboldcpp/koboldcpp-mac-arm64
```

Note: ExFAT does not store Unix permissions. You need to run chmod every time you plug the SSD into a Mac.

---

## "zsh: exec format error" on macOS / Eroare de format pe macOS

**Cause:** Running an x86 binary on Apple Silicon (or vice versa).

**Solution:** Make sure you downloaded the correct binary:
- Apple Silicon (M1/M2/M3/M4): `koboldcpp-mac-arm64`
- Intel Mac: Use llamafile only (KoboldCpp doesn't have Intel macOS builds)

---

## Kiwix doesn't find ZIM files / Kiwix nu gaseste fisierele ZIM

**Windows:**
- Open Kiwix → Hamburger menu → "Open a file" → Navigate to `knowledge/` folder
- Or drag-drop a .zim file onto Kiwix window

**macOS:**
- Kiwix → File → Open File → Navigate to the SSD → `knowledge/`

**Android:**
- Use the FULL Kiwix APK (from `apps/android/`), NOT the Play Store version
- The Play Store version has storage restrictions on Android 11+

---

## SSD not recognized / SSD-ul nu este recunoscut

**Windows:**
- Try a different USB port (prefer USB 3.0+ blue ports)
- Try the other connector (USB-A vs USB-C)
- Check Device Manager for unknown devices

**macOS:**
- Check Disk Utility for the SSD
- Try: `diskutil list` in Terminal

**Android:**
- Not all phones support USB-OTG. Check your phone's specs.
- Try a powered USB hub if the phone can't supply enough power
- Go to Settings → Storage → check if external storage appears

---

## ExFAT corruption / Coruptie ExFAT

**Symptoms:** Files missing, weird filenames, errors when opening files.

**Prevention:** ALWAYS safely eject the SSD before disconnecting:
- Windows: Right-click tray icon → Eject
- macOS: Drag to trash or right-click → Eject
- Android: Settings → Storage → Eject

**Recovery:**
- Windows: Right-click SSD → Properties → Tools → Error Checking → Scan
- macOS: Disk Utility → Select SSD → First Aid

---

## AI server won't start / Serverul AI nu porneste

**Check:**
1. Is port 8080 (or 5001) already in use?
   - Windows: `netstat -ano | findstr :8080`
   - macOS/Linux: `lsof -i :8080`
2. Kill the existing process or use a different port
3. Check if the model file is corrupted (re-download if size is wrong)

---

## Download interrupted / Descarcare intrerupta

The download scripts support resume. Simply run the script again:
```bash
./setup/download-knowledge.sh
```

curl's `-C -` flag automatically resumes from where it stopped.

---

## Not enough space on SSD / Nu este suficient spatiu pe SSD

Check available space:
- Windows: Right-click SSD → Properties
- macOS: `df -h /Volumes/YOUR_SSD`

**Space-saving tips:**
- Use "nopic" (text-only) Wikipedia instead of "maxi" (saves ~65 GB)
- Use only Qwen3-4B (2.5 GB) instead of all models (saves ~20 GB)
- Skip the encrypted vault (saves ~200 GB)
- Use "Minimal" profile for knowledge bases (saves ~145 GB)
