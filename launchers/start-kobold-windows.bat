@echo off

title Red Alert LLM - KoboldCpp

set "DRIVE=%~dp0.."

echo.
echo  Starting KoboldCpp... / Se porneste KoboldCpp...
echo.

:: Find best model
set "MODEL_PATH="
if exist "%DRIVE%\models\primary\qwen3-14b-q4_k_m.gguf" set "MODEL_PATH=%DRIVE%\models\primary\qwen3-14b-q4_k_m.gguf"
if "%MODEL_PATH%"=="" if exist "%DRIVE%\models\primary\qwen3-8b-q4_k_m.gguf" set "MODEL_PATH=%DRIVE%\models\primary\qwen3-8b-q4_k_m.gguf"
if "%MODEL_PATH%"=="" if exist "%DRIVE%\models\primary\qwen3-4b-q4_k_m.gguf" set "MODEL_PATH=%DRIVE%\models\primary\qwen3-4b-q4_k_m.gguf"
if "%MODEL_PATH%"=="" if exist "%DRIVE%\models\alternatives\gemma-3-4b-it-q4_k_m.gguf" set "MODEL_PATH=%DRIVE%\models\alternatives\gemma-3-4b-it-q4_k_m.gguf"

if "%MODEL_PATH%"=="" (
    echo  [ERROR] No model found! Run setup first.
    pause
    exit /b 1
)

echo  Model: %MODEL_PATH%
echo.
"%DRIVE%\engines\koboldcpp\koboldcpp-nocuda.exe" --model "%MODEL_PATH%" --contextsize 4096 --port 5001
pause
