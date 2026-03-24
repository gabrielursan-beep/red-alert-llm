@echo off

title Red Alert LLM - Kiwix Wikipedia Offline

set "DRIVE=%~dp0.."

echo.
echo  ============================================
echo   Kiwix - Wikipedia Offline
echo  ============================================
echo.

:: Check if Kiwix exists
if exist "%DRIVE%\apps\kiwix\kiwix-windows\kiwix-desktop.exe" (
    echo  Starting Kiwix Desktop...
    echo  Se porneste Kiwix Desktop...
    echo.
    echo  ZIM files are in: %DRIVE%\knowledge\
    echo  Fisierele ZIM sunt in: %DRIVE%\knowledge\
    echo.
    start "" "%DRIVE%\apps\kiwix\kiwix-windows\kiwix-desktop.exe"
    echo  Kiwix started! It should open automatically.
    echo  Kiwix pornit! Ar trebui sa se deschida automat.
) else (
    echo  [WARNING] Kiwix Desktop not found!
    echo  [ATENTIE] Kiwix Desktop nu a fost gasit!
    echo.
    echo  Download Kiwix from: https://kiwix.org/en/applications/
    echo  Descarcati Kiwix de la: https://kiwix.org/en/applications/
    echo.
    echo  Extract to: %DRIVE%\apps\kiwix\kiwix-windows\
    echo  Extrageti in: %DRIVE%\apps\kiwix\kiwix-windows\
    echo.
    echo  ZIM files are already in: %DRIVE%\knowledge\
)
echo.
pause
