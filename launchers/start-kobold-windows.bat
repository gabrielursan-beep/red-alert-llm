@echo off
title Red Alert LLM - KoboldCpp

set "DRIVE=%~dp0.."

echo.
echo  ============================================
echo   RED ALERT LLM - KoboldCpp
echo  ============================================
echo.

:: Detect RAM
for /f "skip=1 tokens=*" %%i in ('wmic computersystem get totalphysicalmemory 2^>nul') do (
    set "RAW_RAM=%%i"
    goto :got_ram
)
:got_ram
set "RAW_RAM=%RAW_RAM: =%"
set /a "RAM_GB=%RAW_RAM:~0,-9%"
if "%RAM_GB%"=="" set "RAM_GB=8"

echo  Detected RAM: %RAM_GB% GB
echo.

:: Select model based on RAM
set "MODEL_PATH="

if %RAM_GB% GEQ 16 (
    if exist "%DRIVE%\models\primary\qwen3-14b-q4_k_m.gguf" (
        set "MODEL_PATH=%DRIVE%\models\primary\qwen3-14b-q4_k_m.gguf"
        set "MODEL_NAME=Qwen3-14B (Premium)"
    )
)

if "%MODEL_PATH%"=="" if %RAM_GB% GEQ 12 (
    if exist "%DRIVE%\models\primary\qwen3-8b-q4_k_m.gguf" (
        set "MODEL_PATH=%DRIVE%\models\primary\qwen3-8b-q4_k_m.gguf"
        set "MODEL_NAME=Qwen3-8B (Enhanced)"
    )
)

if "%MODEL_PATH%"=="" (
    if exist "%DRIVE%\models\primary\qwen3-4b-q4_k_m.gguf" (
        set "MODEL_PATH=%DRIVE%\models\primary\qwen3-4b-q4_k_m.gguf"
        set "MODEL_NAME=Qwen3-4B (Standard)"
    )
)

if "%MODEL_PATH%"=="" (
    if exist "%DRIVE%\models\alternatives\gemma-3-4b-it-q4_k_m.gguf" (
        set "MODEL_PATH=%DRIVE%\models\alternatives\gemma-3-4b-it-q4_k_m.gguf"
        set "MODEL_NAME=Gemma-3-4B (Lightweight)"
    )
)

if "%MODEL_PATH%"=="" (
    echo  [ERROR] No model found! Run setup first.
    pause
    exit /b 1
)

echo  Model: %MODEL_NAME%
echo.
"%DRIVE%\engines\koboldcpp\koboldcpp-nocuda.exe" --model "%MODEL_PATH%" --host 127.0.0.1 --contextsize 4096 --port 5001
pause
