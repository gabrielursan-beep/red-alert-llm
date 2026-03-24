@echo off
title Red Alert LLM - Verify Setup

echo.
echo  ============================================
echo   Red Alert LLM - Setup Verification
echo  ============================================
echo.

set "DRIVE=%~dp0.."
set "PASS=0"
set "FAIL=0"
set "WARN=0"

:: --- AI Engines ---
echo  [AI ENGINES]

if exist "%DRIVE%\engines\llamafile\llamafile-windows.exe" (
    echo    [PASS] llamafile-windows.exe found
    set /a PASS+=1
) else (
    echo    [FAIL] llamafile-windows.exe MISSING
    set /a FAIL+=1
)

if exist "%DRIVE%\engines\koboldcpp\koboldcpp-nocuda.exe" (
    echo    [PASS] koboldcpp-nocuda.exe found
    set /a PASS+=1
) else (
    echo    [WARN] koboldcpp-nocuda.exe missing (optional)
    set /a WARN+=1
)
echo.

:: --- AI Models ---
echo  [AI MODELS]

set "MODEL_FOUND=0"
if exist "%DRIVE%\models\primary\qwen3-4b-q4_k_m.gguf" (
    echo    [PASS] qwen3-4b-q4_k_m.gguf found
    set /a PASS+=1
    set "MODEL_FOUND=1"
)
if exist "%DRIVE%\models\primary\qwen3-8b-q4_k_m.gguf" (
    echo    [PASS] qwen3-8b-q4_k_m.gguf found
    set /a PASS+=1
    set "MODEL_FOUND=1"
)
if exist "%DRIVE%\models\primary\qwen3-14b-q4_k_m.gguf" (
    echo    [PASS] qwen3-14b-q4_k_m.gguf found
    set /a PASS+=1
    set "MODEL_FOUND=1"
)
if exist "%DRIVE%\models\alternatives\gemma-3-4b-it-q4_k_m.gguf" (
    echo    [PASS] gemma-3-4b-it-q4_k_m.gguf found
    set /a PASS+=1
    set "MODEL_FOUND=1"
)

if "%MODEL_FOUND%"=="0" (
    echo    [FAIL] No AI model found! Run setup first.
    set /a FAIL+=1
)

if exist "%DRIVE%\models\mobile\qwen3-4b-q3_k_m.gguf" (
    echo    [PASS] Mobile model qwen3-4b-q3_k_m.gguf found
    set /a PASS+=1
) else (
    echo    [WARN] Mobile model missing - for phones
    set /a WARN+=1
)
echo.

:: --- Kiwix ---
echo  [KIWIX]

if exist "%DRIVE%\apps\kiwix\kiwix-windows\kiwix-desktop.exe" (
    echo    [PASS] kiwix-desktop.exe found
    set /a PASS+=1
) else (
    echo    [WARN] kiwix-desktop.exe missing
    echo           Download from: https://kiwix.org/en/applications/
    set /a WARN+=1
)

if exist "%DRIVE%\apps\kiwix\kiwix-windows\.portable" (
    echo    [PASS] .portable file exists - portable mode enabled
    set /a PASS+=1
) else (
    echo    [WARN] .portable file missing in kiwix-windows/
    set /a WARN+=1
)
echo.

:: --- Knowledge Bases ---
echo  [KNOWLEDGE BASES]

set "ZIM_COUNT=0"
for %%f in ("%DRIVE%\knowledge\*.zim") do set /a ZIM_COUNT+=1
for %%f in ("%DRIVE%\knowledge\stackexchange\*.zim") do set /a ZIM_COUNT+=1

if %ZIM_COUNT% GTR 0 (
    echo    [PASS] %ZIM_COUNT% ZIM files found
    set /a PASS+=1
) else (
    echo    [WARN] No ZIM files found. Run: setup\download-knowledge.sh
    set /a WARN+=1
)
echo.

:: --- Config Files ---
echo  [CONFIG]

if exist "%DRIVE%\config\models.json" (
    echo    [PASS] models.json found
    set /a PASS+=1
) else (
    echo    [FAIL] models.json MISSING
    set /a FAIL+=1
)

if exist "%DRIVE%\config\knowledge.json" (
    echo    [PASS] knowledge.json found
    set /a PASS+=1
) else (
    echo    [FAIL] knowledge.json MISSING
    set /a FAIL+=1
)
echo.

:: --- Summary ---
echo  ============================================
echo   RESULTS: %PASS% PASS / %FAIL% FAIL / %WARN% WARN
echo  ============================================

if %FAIL% EQU 0 (
    echo.
    echo   Setup is READY! Launch with: launchers\start-windows.bat
    echo   Setup-ul este GATA! Lansati cu: launchers\start-windows.bat
) else (
    echo.
    echo   Some components are missing. Run setup\setup-windows.bat
    echo   Cateva componente lipsesc. Rulati setup\setup-windows.bat
)
echo.
pause
