@echo off
chcp 65001 >nul 2>&1
echo.
echo  ╔══════════════════════════════════════════╗
echo  ║  Red Alert LLM — Create Encrypted Vault  ║
echo  ╚══════════════════════════════════════════╝
echo.
echo  This will create a 200 GB encrypted container.
echo  You need VeraCrypt installed or in apps\veracrypt\
echo.
echo  Steps:
echo  1. Open VeraCrypt (apps\veracrypt\veracrypt-portable-windows\VeraCrypt.exe)
echo  2. Click "Create Volume"
echo  3. "Create an encrypted file container" - Next
echo  4. "Standard VeraCrypt volume" - Next
echo  5. Select File: choose this SSD root, name it "vault.hc" - Next
echo  6. Encryption: AES, Hash: SHA-512 - Next
echo  7. Size: 200 GB (or your preference) - Next
echo  8. Choose a STRONG password (20+ characters) - Next
echo  9. Filesystem: ExFAT - Next
echo  10. Move mouse randomly for 30 seconds - Format
echo.
echo  See docs\guide-vault.md for full instructions.
echo.

set "DRIVE=%~dp0.."
if exist "%DRIVE%\apps\veracrypt\veracrypt-portable-windows\VeraCrypt.exe" (
    echo  Opening VeraCrypt...
    start "" "%DRIVE%\apps\veracrypt\veracrypt-portable-windows\VeraCrypt.exe"
) else (
    echo  VeraCrypt not found. Download from: https://www.veracrypt.fr/en/Downloads.html
    echo  Extract portable version to: apps\veracrypt\veracrypt-portable-windows\
)
echo.
pause
