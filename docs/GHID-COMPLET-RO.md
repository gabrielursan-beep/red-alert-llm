# Ghid Complet — Red Alert LLM

## 1. Ce sa cumparati

### SSD USB recomandat
**SSD Portabil Dual Kingston, 1TB, USB Type-A/USB Type-C, USB 3.2 Gen 2, rosu/negru** — **743 RON** (pret martie 2026)
- Are ambele mufe: USB-A (clasic) + USB-C (nou)
- Viteza: 1,050 MB/s citire
- Dimensiune: cat un breloc (28 grame)
- Functioneaza pe Windows, Mac, telefoane Android cu OTG
- [Cumpara de pe eMAG.ro](https://bit.ly/4uEu0nA)*

*\* Link afiliat — cumparand prin acest link sustineti proiectul fara cost suplimentar pentru dvs.*

### Alternative
Orice SSD sau stick USB 3.0+ cu minim 256 GB functioneaza. Drive-urile mai mici/lente sunt compatibile dar vor avea timpi de incarcare mai mari si mai putin spatiu.

### Cablu USB-OTG (pentru telefon)
Daca telefonul are USB-C, SSD-ul se conecteaza direct. Daca are micro-USB, aveti nevoie de un adaptor OTG (~20 RON pe eMAG).

---

## 2. Verificarea formatului ExFAT

SSD-ul Kingston vine deja formatat ExFAT — **nu trebuie sa faceti nimic**. Daca l-ati reformatat, verificati:

**Windows:**
1. Conectati SSD-ul
2. Deschideti "This PC" / "Acest PC"
3. Click dreapta pe SSD → Properties
4. File system trebuie sa fie **ExFAT**

**macOS:**
1. Conectati SSD-ul
2. Deschideti Disk Utility (Utilitarul de discuri)
3. Selectati SSD-ul si verificati ca formatul este **ExFAT**

---

## 3. Clonarea repository-ului

### Varianta 1: Cu Git (recomandat)
```bash
git clone https://github.com/gabrielursan-beep/red-alert-llm.git
```
Copiati folderul `red-alert-llm/` pe SSD.

### Varianta 2: Fara Git
Descarcati ZIP de pe GitHub → Extract → Copiati pe SSD.

---

## 4. Rularea scriptului de setup

### Pe Windows
1. Deschideti folderul `red-alert-llm` de pe SSD
2. Dublu-click pe `setup/setup-windows.bat`
3. Scriptul descarca automat:
   - llamafile (motorul AI) — ~700 MB
   - KoboldCpp (motor AI alternativ) — ~90 MB
   - Modelul AI Qwen3 — 2.5-9 GB (in functie de RAM)
   - Model pentru telefon — ~2 GB
4. Asteptati sa se termine (10-30 minute in functie de internet)

### Pe macOS
1. Deschideti Terminal
2. Navigati la SSD: `cd /Volumes/KINGSTON/red-alert-llm` (sau numele SSD-ului)
3. Rulati:
```bash
chmod +x setup/setup-mac.sh
./setup/setup-mac.sh
```
4. Daca macOS blocheaza executia, vedeti sectiunea "Probleme cu Gatekeeper"

---

## 5. Descarcarea bazei de cunostinte

Bazele de cunostinte (Wikipedia etc.) se descarca separat deoarece sunt foarte mari.

1. Deschideti un terminal bash:
   - **Windows:** instalati Git Bash sau folositi WSL
   - **macOS/Linux:** Terminal nativ
2. Navigati la SSD
3. Rulati:
```bash
chmod +x setup/download-knowledge.sh
./setup/download-knowledge.sh
```
4. Alegeti un profil:
   - **M (Minimal)** — ~55 GB: Wikipedia EN text + RO text + enciclopedie medicala
   - **R (Recomandat)** — ~80 GB: + iFixit, dictionar, ghiduri calatorie
   - **F (Full)** — ~200 GB: Tot, inclusiv Wikipedia cu imagini
5. Confirmati si asteptati (poate dura ore, depinde de internet)

**Daca se intrerupe:** rulati din nou scriptul — descarcarea se reia de unde a ramas.

---

## 6. Primul test pe Windows

1. Dublu-click pe `launchers/start-windows.bat`
2. Scriptul detecteaza automat RAM-ul si alege modelul potrivit
3. Alegeti motorul: 1 (llamafile) sau 2 (KoboldCpp)
4. Se deschide browserul la `http://localhost:8080`
5. Scrieti un mesaj si asteptati raspunsul!

### Daca Windows SmartScreen blocheaza
- Click "More info" / "Mai multe informatii"
- Click "Run anyway" / "Ruleaza oricum"
- Sau: click dreapta pe .exe → Properties → bifati "Unblock"

---

## 7. Primul test pe macOS

1. Dublu-click pe `launchers/start-macos.command`
2. Daca macOS spune "cannot be opened": click dreapta → Open → Open
3. Se deschide Terminal-ul cu scriptul
4. Alegeti motorul si asteptati incarcarea modelului
5. Browserul se deschide automat

### Probleme cu Gatekeeper

macOS blocheaza programe neinsemnate digital. Rezolvare:

**Metoda 1 (automata):** Scriptul de setup ruleaza `xattr -dr com.apple.quarantine` automat.

**Metoda 2 (manuala):**
```bash
xattr -dr com.apple.quarantine /Volumes/SSD/red-alert-llm/engines/
```

**Metoda 3 (din System Settings):**
System Settings → Privacy & Security → scroll jos → "Open Anyway"

---

## 8. Performanta asteptata

| Computer | RAM | Model | Viteza |
|----------|-----|-------|--------|
| MacBook Air M1 | 8 GB | Qwen3-4B | ~25-35 cuvinte/sec |
| MacBook Pro M2 | 16 GB | Qwen3-8B | ~40-55 cuvinte/sec |
| PC Intel i5 gen 12 | 16 GB | Qwen3-4B | ~10-18 cuvinte/sec |
| PC AMD Ryzen 5 | 32 GB | Qwen3-14B | ~15-25 cuvinte/sec |
| PC + NVIDIA RTX 3060 | 16 GB | Qwen3-8B | ~40-60 cuvinte/sec |

**Ce conteaza cel mai mult:** latime de banda a memoriei (Apple Silicon este cel mai rapid), apoi accelerare GPU.

---

## 9. Pe telefon (Android)

1. Conectati SSD-ul la telefon cu cablu USB-C (sau adaptor OTG)
2. Instalati **PocketPal AI** din Play Store
   - Sau descarcati APK-ul din `apps/android/pocketpal-ai.apk` de pe SSD
3. Din file manager, copiati `models/mobile/qwen3-4b-q3_k_m.gguf` (~2 GB) pe telefon
4. Deschideti PocketPal AI → incarcati modelul
5. Vorbiti cu AI-ul offline!

**Pentru Wikipedia pe telefon:**
1. Instalati Kiwix APK din `apps/android/kiwix-android-full.apk`
   - **Important:** NU versiunea din Play Store (are restrictii de acces la fisiere)
2. Deschideti Kiwix → navigati la SSD → knowledge → selectati un fisier .zim

---

## 10. Pe telefon (iOS)

1. Conectati SSD-ul la iPhone cu USB-C (sau adaptor Lightning)
2. Instalati **PocketPal AI** din App Store
3. Deschideti Files → navigati la SSD → models/mobile/
4. Copiati `qwen3-4b-q3_k_m.gguf` (~2 GB) pe "On My iPhone"
5. In PocketPal AI, importati modelul
6. Vorbiti cu AI-ul offline!

**Limitari iOS:**
- Modelul trebuie copiat pe telefon (nu merge direct de pe SSD)
- iPhone-uri cu 4 GB RAM pot avea dificultati
- Recomandat: iPhone 15 Pro sau mai nou (8 GB RAM)

---

## 11. Cum sa adaugati modele noi

1. Gasiti un model GGUF pe HuggingFace (cautati "Q4_K_M")
2. Descarcati fisierul .gguf
3. Copiati in `models/primary/` sau `models/alternatives/`
4. Editati `config/models.json` sa adaugati noul model
5. Lansati AI-ul — modelul va fi disponibil

### Modele recomandate pentru romana
- **Qwen3** (orice dimensiune) — cel mai bun suport pentru romana
- **Gemma 3** — alternativa buna, 140+ limbi
- **Evitati:** Phi-4 (suport slab pentru romana)

---

## 12. Cum sa actualizati Wikipedia

ZIM-urile se actualizeaza lunar pe https://download.kiwix.org/zim/

1. Verificati daca exista versiune noua
2. Descarcati noul .zim
3. Stergeti .zim-ul vechi din `knowledge/`
4. Puneti noul .zim in locul lui
5. Deschideti Kiwix — va folosi automat noul fisier

---

## 13. Seiful criptat (VeraCrypt)

### Ce este
Un fisier de 200 GB (`vault.hc`) care functioneaza ca un hard disk virtual criptat. Nimeni nu poate vedea continutul fara parola.

### Pe Windows (portabil, fara instalare)
1. Deschideti `apps/veracrypt/veracrypt-portable-windows/`
2. Rulati VeraCrypt.exe
3. Select File → navigati la `vault.hc`
4. Mount → introduceti parola → aveti acces la fisiere

### Pe macOS (necesita instalare o singura data)
1. Instalati VeraCrypt de pe veracrypt.fr (+ macFUSE)
2. Deschideti VeraCrypt
3. Select File → vault.hc → Mount → parola

### Ce sa puneti in seif
- Documente de identitate (scanari CI, pasaport)
- Dosare medicale, retete, analize
- Documente financiare, declaratii fiscale
- Baza de date parole (KeePass)
- Poze importante, certificari
- Backup telefon

---

## Intrebari frecvente

**Trebuie sa am internet?**
Nu. Totul functioneaza offline. Internetul e necesar doar pentru setup (descarcarea initiala).

**Cat costa?**
Software-ul este gratuit. Platiti doar SSD-ul (743 RON pentru Kingston 1TB — [eMAG.ro](https://bit.ly/4uEu0nA)*).

**Este sigur sa pastrez date personale?**
Da, in seiful VeraCrypt. Fara parola, datele sunt necitibile. In afara seifului, oricine cu acces fizic la SSD poate vedea fisierele.

**Pot folosi pe mai multe computere?**
Da! Acesta este scopul — scoateti SSD-ul dintr-un computer si il conectati la altul.

**Cat de bun este AI-ul?**
Qwen3-14B este comparabil cu ChatGPT gratuit (GPT-3.5) pentru majoritatea sarcinilor. Este excelent pentru intrebari, traduceri, ajutor cu cod, si cunostinte generale.

**Trebuie sa am laptop puternic?**
Nu neaparat. Orice computer cu 8 GB RAM functioneaza. Cu 16 GB sau GPU NVIDIA, performanta este semnificativ mai buna.
