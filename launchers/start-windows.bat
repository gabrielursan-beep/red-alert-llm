@echo off

title Red Alert LLM - AI Assistant

echo.
echo  ============================================
echo   RED ALERT LLM - AI Assistant
echo   Asistent AI Offline Portabil
echo  ============================================
echo.

set "DRIVE=%~dp0.."

:: --- Detect RAM ---
for /f "skip=1 tokens=*" %%i in ('wmic computersystem get totalphysicalmemory 2^>nul') do (
    set "RAW_RAM=%%i"
    goto :got_ram
)
:got_ram
:: Remove spaces
set "RAW_RAM=%RAW_RAM: =%"
:: Calculate GB (divide by ~1073741824 using simple arithmetic)
set /a "RAM_GB=%RAW_RAM:~0,-9%"
if "%RAM_GB%"=="" set "RAM_GB=8"

echo  Detected RAM / RAM detectat: %RAM_GB% GB
echo.

:: --- Select model based on RAM ---
set "MODEL_PATH="
set "MODEL_NAME="

if %RAM_GB% GEQ 16 (
    if exist "%DRIVE%\models\primary\qwen3-14b-q4_k_m.gguf" (
        set "MODEL_PATH=%DRIVE%\models\primary\qwen3-14b-q4_k_m.gguf"
        set "MODEL_NAME=Qwen3-14B (Premium, 9 GB)"
    )
)

if "%MODEL_PATH%"=="" if %RAM_GB% GEQ 12 (
    if exist "%DRIVE%\models\primary\qwen3-8b-q4_k_m.gguf" (
        set "MODEL_PATH=%DRIVE%\models\primary\qwen3-8b-q4_k_m.gguf"
        set "MODEL_NAME=Qwen3-8B (Enhanced, 5 GB)"
    )
)

if "%MODEL_PATH%"=="" if %RAM_GB% GEQ 8 (
    if exist "%DRIVE%\models\primary\qwen3-4b-q4_k_m.gguf" (
        set "MODEL_PATH=%DRIVE%\models\primary\qwen3-4b-q4_k_m.gguf"
        set "MODEL_NAME=Qwen3-4B (Standard, 2.5 GB)"
    )
)

if "%MODEL_PATH%"=="" (
    if exist "%DRIVE%\models\alternatives\gemma-3-4b-it-q4_k_m.gguf" (
        set "MODEL_PATH=%DRIVE%\models\alternatives\gemma-3-4b-it-q4_k_m.gguf"
        set "MODEL_NAME=Gemma-3-4B (Lightweight, 2.5 GB)"
    )
)

if "%MODEL_PATH%"=="" (
    echo  [ERROR] No AI model found! / Nu s-a gasit niciun model AI!
    echo  Run setup first: setup\setup-windows.bat
    echo  Rulati setup-ul intai: setup\setup-windows.bat
    echo.
    pause
    exit /b 1
)

echo  Model selected / Model selectat: %MODEL_NAME%
echo.

:: --- Detect NVIDIA GPU ---
set "GPU_FLAGS="
where nvidia-smi >nul 2>&1
if %errorlevel%==0 (
    echo  NVIDIA GPU detected! Enabling CUDA acceleration.
    echo  GPU NVIDIA detectat! Se activeaza accelerarea CUDA.
    set "GPU_FLAGS=-ngl 999"
    echo.
)

:: --- Choose engine ---
echo  Choose AI engine / Alegeti motorul AI:
echo    1. llamafile (simplu, recomandat / simple, recommended)
echo    2. KoboldCpp (interfata mai bogata / richer interface)
echo.
set /p "choice=  Type 1 or 2 / Tastati 1 sau 2: "

if "%choice%"=="2" goto :kobold

:: --- llamafile ---
echo.
echo  Starting llamafile... / Se porneste llamafile...
echo  Loading model: %MODEL_NAME%
echo.
echo  --------------------------------------------------
echo   Open browser at / Deschideti browserul:
echo   http://localhost:8080
echo.
echo   To stop / Pentru oprire: Ctrl+C
echo  --------------------------------------------------
echo.

:: Auto-open browser after 3 seconds
start "" /b cmd /c "timeout /t 5 /nobreak >nul && start http://localhost:8080"

"%DRIVE%\engines\llamafile\llamafile-windows.exe" -m "%MODEL_PATH%" --host 127.0.0.1 --port 8080 -c 4096 %GPU_FLAGS%
goto :end

:kobold
echo.
echo  Starting KoboldCpp... / Se porneste KoboldCpp...
echo  Loading model: %MODEL_NAME%
echo.

"%DRIVE%\engines\koboldcpp\koboldcpp-nocuda.exe" --model "%MODEL_PATH%" --contextsize 4096 --port 5001
goto :end

:end
echo.
echo  AI server stopped. / Serverul AI s-a oprit.
pause
