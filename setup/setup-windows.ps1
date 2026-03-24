# ============================================================
# Red Alert LLM — Windows Setup Script (PowerShell)
# ============================================================
# Downloads AI engines, models, and Kiwix reader.
# Run from the red-alert-llm folder on the SSD.
# Usage: powershell -ExecutionPolicy Bypass -File setup-windows.ps1
# ============================================================

param(
    [string]$DrivePath = "",
    [switch]$SkipKnowledge,
    [switch]$SkipKiwix,
    [string]$ModelTier = "auto"
)

$ErrorActionPreference = "Stop"

# --- Banner ---
Write-Host ""
Write-Host "  ============================================" -ForegroundColor Red
Write-Host "  RED ALERT LLM — Setup for Windows" -ForegroundColor Red
Write-Host "  ============================================" -ForegroundColor Red
Write-Host ""
Write-Host "  Portable Offline AI Assistant + Knowledge Base"
Write-Host "  Asistent AI Portabil Offline + Baza de Cunostinte"
Write-Host ""

# --- Detect project root ---
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir

if (-not (Test-Path "$ProjectRoot\config\models.json")) {
    Write-Host "  [ERROR] Cannot find config\models.json" -ForegroundColor Red
    Write-Host "  Make sure this script is in the setup\ folder of the project." -ForegroundColor Red
    exit 1
}

Write-Host "  Project root: $ProjectRoot" -ForegroundColor Cyan
Write-Host ""

# --- Detect RAM ---
$TotalRAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
Write-Host "  Detected RAM: $TotalRAM GB" -ForegroundColor Green

# --- Select model based on RAM ---
if ($ModelTier -eq "auto") {
    if ($TotalRAM -ge 16) {
        $SelectedModel = "qwen3-14b"
        $ModelFile = "qwen3-14b-q4_k_m.gguf"
        $ModelURL = "https://huggingface.co/bartowski/Qwen_Qwen3-14B-GGUF/resolve/main/Qwen_Qwen3-14B-Q4_K_M.gguf"
        $ModelSize = "9 GB"
        $ModelFolder = "primary"
    } elseif ($TotalRAM -ge 12) {
        $SelectedModel = "qwen3-8b"
        $ModelFile = "qwen3-8b-q4_k_m.gguf"
        $ModelURL = "https://huggingface.co/bartowski/Qwen_Qwen3-8B-GGUF/resolve/main/Qwen_Qwen3-8B-Q4_K_M.gguf"
        $ModelSize = "5 GB"
        $ModelFolder = "primary"
    } elseif ($TotalRAM -ge 8) {
        $SelectedModel = "qwen3-4b"
        $ModelFile = "qwen3-4b-q4_k_m.gguf"
        $ModelURL = "https://huggingface.co/bartowski/Qwen_Qwen3-4B-GGUF/resolve/main/Qwen_Qwen3-4B-Q4_K_M.gguf"
        $ModelSize = "2.5 GB"
        $ModelFolder = "primary"
    } else {
        $SelectedModel = "gemma-3-4b"
        $ModelFile = "gemma-3-4b-it-q4_k_m.gguf"
        $ModelURL = "https://huggingface.co/ggml-org/gemma-3-4b-it-GGUF/resolve/main/gemma-3-4b-it-Q4_K_M.gguf"
        $ModelSize = "2.5 GB"
        $ModelFolder = "alternatives"
    }
} else {
    # Manual tier selection
    switch ($ModelTier) {
        "4b"  { $ModelFile = "qwen3-4b-q4_k_m.gguf"; $ModelURL = "https://huggingface.co/bartowski/Qwen_Qwen3-4B-GGUF/resolve/main/Qwen_Qwen3-4B-Q4_K_M.gguf"; $ModelSize = "2.5 GB"; $ModelFolder = "primary" }
        "8b"  { $ModelFile = "qwen3-8b-q4_k_m.gguf"; $ModelURL = "https://huggingface.co/bartowski/Qwen_Qwen3-8B-GGUF/resolve/main/Qwen_Qwen3-8B-Q4_K_M.gguf"; $ModelSize = "5 GB"; $ModelFolder = "primary" }
        "14b" { $ModelFile = "qwen3-14b-q4_k_m.gguf"; $ModelURL = "https://huggingface.co/bartowski/Qwen_Qwen3-14B-GGUF/resolve/main/Qwen_Qwen3-14B-Q4_K_M.gguf"; $ModelSize = "9 GB"; $ModelFolder = "primary" }
        default { Write-Host "  [ERROR] Unknown tier: $ModelTier. Use 4b, 8b, or 14b." -ForegroundColor Red; exit 1 }
    }
    $SelectedModel = $ModelTier
}

Write-Host "  Selected model: $SelectedModel ($ModelSize)" -ForegroundColor Green
Write-Host ""

# --- Helper: Download with progress ---
function Download-File {
    param(
        [string]$Url,
        [string]$Destination,
        [string]$Description
    )

    if (Test-Path $Destination) {
        $size = (Get-Item $Destination).Length
        if ($size -gt 1MB) {
            Write-Host "  [SKIP] $Description already exists ($([math]::Round($size/1MB)) MB)" -ForegroundColor Yellow
            return
        }
    }

    Write-Host "  [DOWNLOAD] $Description" -ForegroundColor Cyan
    Write-Host "  URL: $Url" -ForegroundColor DarkGray
    Write-Host "  Destination: $Destination" -ForegroundColor DarkGray

    $parentDir = Split-Path -Parent $Destination
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    try {
        # Try BITS transfer first (shows progress, supports resume)
        $bitsJob = Start-BitsTransfer -Source $Url -Destination $Destination -DisplayName $Description -ErrorAction Stop
        Write-Host "  [OK] $Description downloaded successfully" -ForegroundColor Green
    } catch {
        Write-Host "  [INFO] BITS transfer failed, trying direct download..." -ForegroundColor Yellow
        try {
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $Url -OutFile $Destination -UseBasicParsing
            $ProgressPreference = 'Continue'
            Write-Host "  [OK] $Description downloaded successfully" -ForegroundColor Green
        } catch {
            Write-Host "  [ERROR] Failed to download $Description" -ForegroundColor Red
            Write-Host "  Error: $_" -ForegroundColor Red
            Write-Host "  Try downloading manually: $Url" -ForegroundColor Yellow
            return
        }
    }

    # Verify file size
    if (Test-Path $Destination) {
        $size = (Get-Item $Destination).Length
        Write-Host "  [INFO] File size: $([math]::Round($size/1MB)) MB" -ForegroundColor DarkGray
    }
}

# --- Create folder structure ---
Write-Host "  Creating folder structure..." -ForegroundColor Cyan
$folders = @(
    "engines\llamafile",
    "engines\koboldcpp",
    "engines\whisperfile",
    "models\primary",
    "models\alternatives",
    "models\specialized",
    "models\mobile",
    "knowledge\stackexchange",
    "apps\kiwix\kiwix-windows",
    "apps\veracrypt",
    "apps\android"
)
foreach ($folder in $folders) {
    $path = Join-Path $ProjectRoot $folder
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
}
Write-Host "  [OK] Folder structure created" -ForegroundColor Green
Write-Host ""

# --- Download llamafile ---
Write-Host "  ========================================" -ForegroundColor Cyan
Write-Host "  Step 1/4: AI Engine — llamafile v0.10.0" -ForegroundColor Cyan
Write-Host "  ========================================" -ForegroundColor Cyan
Download-File `
    -Url "https://github.com/mozilla-ai/llamafile/releases/download/0.10.0/llamafile-0.10.0" `
    -Destination "$ProjectRoot\engines\llamafile\llamafile-windows.exe" `
    -Description "llamafile v0.10.0 (AI inference engine)"

# --- Download KoboldCpp ---
Write-Host ""
Write-Host "  ========================================" -ForegroundColor Cyan
Write-Host "  Step 2/4: AI Engine — KoboldCpp v1.110" -ForegroundColor Cyan
Write-Host "  ========================================" -ForegroundColor Cyan
Download-File `
    -Url "https://github.com/LostRuins/koboldcpp/releases/download/v1.110/koboldcpp-nocuda.exe" `
    -Destination "$ProjectRoot\engines\koboldcpp\koboldcpp-nocuda.exe" `
    -Description "KoboldCpp v1.110 (alternative AI engine, no CUDA)"

# --- Download AI Model ---
Write-Host ""
Write-Host "  ========================================" -ForegroundColor Cyan
Write-Host "  Step 3/4: AI Model — $SelectedModel" -ForegroundColor Cyan
Write-Host "  ========================================" -ForegroundColor Cyan
Write-Host "  This is the largest download ($ModelSize). Please be patient." -ForegroundColor Yellow
Write-Host "  Aceasta este cea mai mare descarcare ($ModelSize). Va rugam asteptati." -ForegroundColor Yellow
Write-Host ""
Download-File `
    -Url $ModelURL `
    -Destination "$ProjectRoot\models\$ModelFolder\$ModelFile" `
    -Description "$SelectedModel AI model ($ModelSize)"

# Also download the mobile version for phone use
Write-Host ""
Write-Host "  Downloading mobile-optimized model for phones..." -ForegroundColor Cyan
Download-File `
    -Url "https://huggingface.co/bartowski/Qwen_Qwen3-4B-GGUF/resolve/main/Qwen_Qwen3-4B-Q3_K_M.gguf" `
    -Destination "$ProjectRoot\models\mobile\qwen3-4b-q3_k_m.gguf" `
    -Description "Qwen3-4B mobile (Q3_K_M, ~2 GB, for phones)"

# --- Download Kiwix ---
if (-not $SkipKiwix) {
    Write-Host ""
    Write-Host "  ========================================" -ForegroundColor Cyan
    Write-Host "  Step 4/4: Kiwix Desktop (Wikipedia Reader)" -ForegroundColor Cyan
    Write-Host "  ========================================" -ForegroundColor Cyan
    Write-Host "  Note: Kiwix must be downloaded as a ZIP and extracted." -ForegroundColor Yellow
    Write-Host "  Visit https://kiwix.org/en/applications/ to download the Windows version." -ForegroundColor Yellow
    Write-Host "  Extract to: $ProjectRoot\apps\kiwix\kiwix-windows\" -ForegroundColor Yellow
    Write-Host ""

    # Create .portable file for Kiwix portable mode
    $portableFile = "$ProjectRoot\apps\kiwix\kiwix-windows\.portable"
    if (-not (Test-Path $portableFile)) {
        New-Item -ItemType File -Path $portableFile -Force | Out-Null
        Write-Host "  [OK] Created .portable file (enables Kiwix portable mode)" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "  [SKIP] Kiwix download skipped (--SkipKiwix flag)" -ForegroundColor Yellow
}

# --- Summary ---
Write-Host ""
Write-Host "  ============================================" -ForegroundColor Green
Write-Host "  SETUP COMPLETE!" -ForegroundColor Green
Write-Host "  ============================================" -ForegroundColor Green
Write-Host ""
Write-Host "  What was installed:" -ForegroundColor White
Write-Host "    - llamafile v0.10.0 (AI engine)" -ForegroundColor White
Write-Host "    - KoboldCpp v1.110 (alternative AI engine)" -ForegroundColor White
Write-Host "    - $SelectedModel model ($ModelSize)" -ForegroundColor White
Write-Host "    - Qwen3-4B mobile model (for phones)" -ForegroundColor White
Write-Host ""
Write-Host "  Next steps / Pasii urmatori:" -ForegroundColor Yellow
Write-Host "    1. Download knowledge bases: run setup\download-knowledge.sh" -ForegroundColor White
Write-Host "       (requires bash — use Git Bash on Windows)" -ForegroundColor DarkGray
Write-Host "    2. Download Kiwix Desktop from https://kiwix.org/en/applications/" -ForegroundColor White
Write-Host "       Extract ZIP to apps\kiwix\kiwix-windows\" -ForegroundColor DarkGray
Write-Host "    3. Launch AI: double-click launchers\start-windows.bat" -ForegroundColor White
Write-Host "    4. Verify: run tools\verify-setup.bat" -ForegroundColor White
Write-Host ""
Write-Host "  Enjoy your portable offline AI! / Bucurati-va de AI-ul portabil offline!" -ForegroundColor Green
Write-Host ""
