# Encrypted Vault Guide / Ghid Seif Criptat

## What Is the Vault? / Ce este seiful?

The vault is a 200 GB encrypted file (`vault.hc`) on your SSD. When you "mount" it with your password, it appears as a separate drive with your private files. Without the password, the contents are completely unreadable.

Seiful este un fisier criptat de 200 GB (`vault.hc`) pe SSD. Cand il "montati" cu parola, apare ca un drive separat cu fisierele private. Fara parola, continutul este complet necitibil.

## Encryption Details
- **Algorithm:** AES-256
- **Hash:** SHA-512
- **Container filesystem:** ExFAT (cross-platform)
- **Security:** Military-grade. Even if someone steals your SSD, they cannot read vault contents without the password.

## Creating the Vault / Crearea seifului

### On Windows (portable, no install needed)

1. Download VeraCrypt Portable from https://www.veracrypt.fr/en/Downloads.html
   - Choose "VeraCrypt Portable" version
   - Extract to `apps/veracrypt/veracrypt-portable-windows/`
2. Run `VeraCrypt.exe` from the extracted folder
3. Click "Create Volume"
4. Select "Create an encrypted file container" → Next
5. Select "Standard VeraCrypt volume" → Next
6. Click "Select File" → navigate to SSD root → type `vault.hc` → Save → Next
7. Encryption: AES, Hash: SHA-512 → Next
8. Volume Size: 200 GB (or your preferred size) → Next
9. Choose a STRONG password (20+ characters recommended) → Next
10. Filesystem: ExFAT → Next
11. Move your mouse randomly for 30+ seconds (generates encryption key)
12. Click "Format"
13. Wait (~5-10 minutes for 200 GB)

### On macOS

1. Install VeraCrypt from https://www.veracrypt.fr/en/Downloads.html
   - Also install macFUSE (required dependency)
2. Open VeraCrypt → Volumes → Create New Volume
3. Follow same steps as Windows above
4. Volume location: `/Volumes/YOUR_SSD/vault.hc`

## Using the Vault / Utilizarea seifului

### Opening (Mounting) / Deschiderea (Montarea)

**Windows:**
1. Run VeraCrypt from `apps/veracrypt/veracrypt-portable-windows/VeraCrypt.exe`
2. Select a drive letter (e.g., V:)
3. Click "Select File" → navigate to `vault.hc` on SSD
4. Click "Mount"
5. Enter your password → OK
6. Drive V: now contains your encrypted files
7. Open File Explorer → navigate to V:

**macOS:**
1. Open VeraCrypt
2. Click "Select File" → navigate to SSD → `vault.hc`
3. Click "Mount"
4. Enter password → OK
5. Vault appears in Finder as a mounted volume

### Closing (Dismounting) / Inchiderea (Demontarea)

**IMPORTANT:** Always dismount before unplugging the SSD!

1. In VeraCrypt, click "Dismount" (or "Dismount All")
2. Wait for confirmation
3. Then safely eject the SSD

### Recommended Folder Structure

```
vault.hc (when mounted)
├── documents/
│   ├── personal/          # ID scans, passport, birth certificate
│   ├── work/              # Work contracts, NDA
│   └── legal/             # Legal documents, notary acts
├── photos/
│   ├── family/            # Family photos backup
│   └── important/         # Important photos (receipts, damage documentation)
├── medical-records/
│   ├── prescriptions/     # Prescriptions / Retete
│   ├── lab-results/       # Lab results / Analize
│   └── insurance/         # Health insurance / Asigurare medicala
├── financial/
│   ├── tax-returns/       # Tax declarations / Declaratii fiscale
│   ├── investments/       # Investment statements
│   └── receipts/          # Important receipts / Bon-uri importante
├── passwords/
│   └── passwords.kdbx    # KeePass password database
├── certificates/
│   ├── ssl/               # SSL certificates
│   └── personal/          # Personal certificates, diplomas
└── backups/
    ├── phone-backup/      # Phone backup
    └── cloud-export/      # Exported data from cloud services
```

## Security Tips / Sfaturi de securitate

1. **Use a strong password** — at least 20 characters, mix of letters, numbers, symbols
2. **Don't write the password on the SSD** — memorize it or store in a separate password manager
3. **Always dismount before unplugging** — prevents corruption
4. **Make a backup** — copy `vault.hc` to another drive periodically
5. **Hidden volume** — VeraCrypt supports hidden volumes for plausible deniability (advanced)

## Platform Compatibility

| Platform | Can Mount Vault? | Notes |
|----------|-----------------|-------|
| Windows | Yes (portable) | No installation needed |
| macOS | Yes | Needs VeraCrypt + macFUSE installed |
| Linux | Yes | Needs VeraCrypt installed |
| Android | No | VeraCrypt not available |
| iOS | No | VeraCrypt not available |

For Android/iOS, keep non-sensitive files outside the vault in regular folders on the SSD.
