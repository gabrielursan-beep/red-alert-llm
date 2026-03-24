#!/bin/bash
# ============================================================
# Red Alert LLM — macOS Setup Script
# ============================================================
# Downloads AI engines, models, and configures for macOS.
# Run from the red-alert-llm folder on the SSD.
# Usage: chmod +x setup/setup-mac.sh && ./setup/setup-mac.sh
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${RED}  ============================================${NC}"
echo -e "${RED}  RED ALERT LLM — Setup for macOS${NC}"
echo -e "${RED}  ============================================${NC}"
echo ""
echo "  Portable Offline AI Assistant + Knowledge Base"
echo "  Asistent AI Portabil Offline + Baza de Cunostinte"
echo ""
echo -e "${CYAN}  Project root: $PROJECT_ROOT${NC}"
echo ""

# --- Detect RAM ---
RAM_BYTES=$(sysctl -n hw.memsize 2>/dev/null || echo 0)
RAM_GB=$((RAM_BYTES / 1073741824))
echo -e "${GREEN}  Detected RAM: ${RAM_GB} GB${NC}"

# --- Detect Apple Silicon ---
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    echo -e "${GREEN}  Detected: Apple Silicon (Metal GPU acceleration available)${NC}"
    IS_APPLE_SILICON=true
else
    echo -e "${YELLOW}  Detected: Intel Mac (CPU only, no GPU acceleration)${NC}"
    IS_APPLE_SILICON=false
fi

# --- Select model based on RAM ---
if [ $RAM_GB -ge 16 ]; then
    MODEL_NAME="qwen3-14b"
    MODEL_FILE="qwen3-14b-q4_k_m.gguf"
    MODEL_URL="https://huggingface.co/bartowski/Qwen_Qwen3-14B-GGUF/resolve/main/Qwen_Qwen3-14B-Q4_K_M.gguf"
    MODEL_SIZE="9 GB"
    MODEL_FOLDER="primary"
elif [ $RAM_GB -ge 12 ]; then
    MODEL_NAME="qwen3-8b"
    MODEL_FILE="qwen3-8b-q4_k_m.gguf"
    MODEL_URL="https://huggingface.co/bartowski/Qwen_Qwen3-8B-GGUF/resolve/main/Qwen_Qwen3-8B-Q4_K_M.gguf"
    MODEL_SIZE="5 GB"
    MODEL_FOLDER="primary"
elif [ $RAM_GB -ge 8 ]; then
    MODEL_NAME="qwen3-4b"
    MODEL_FILE="qwen3-4b-q4_k_m.gguf"
    MODEL_URL="https://huggingface.co/bartowski/Qwen_Qwen3-4B-GGUF/resolve/main/Qwen_Qwen3-4B-Q4_K_M.gguf"
    MODEL_SIZE="2.5 GB"
    MODEL_FOLDER="primary"
else
    MODEL_NAME="gemma-3-4b"
    MODEL_FILE="gemma-3-4b-it-q4_k_m.gguf"
    MODEL_URL="https://huggingface.co/ggml-org/gemma-3-4b-it-GGUF/resolve/main/gemma-3-4b-it-Q4_K_M.gguf"
    MODEL_SIZE="2.5 GB"
    MODEL_FOLDER="alternatives"
fi

echo -e "${GREEN}  Selected model: $MODEL_NAME ($MODEL_SIZE)${NC}"
echo ""

# --- Helper: Download with curl ---
download_file() {
    local url="$1"
    local dest="$2"
    local desc="$3"

    if [ -f "$dest" ] && [ $(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null || echo 0) -gt 1048576 ]; then
        local size_mb=$(( $(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null || echo 0) / 1048576 ))
        echo -e "${YELLOW}  [SKIP] $desc already exists (${size_mb} MB)${NC}"
        return 0
    fi

    echo -e "${CYAN}  [DOWNLOAD] $desc${NC}"
    echo "  URL: $url"

    local dir=$(dirname "$dest")
    mkdir -p "$dir"

    if curl -L -# -C - -o "$dest" "$url"; then
        echo -e "${GREEN}  [OK] $desc downloaded successfully${NC}"
    else
        echo -e "${RED}  [ERROR] Failed to download $desc${NC}"
        echo "  Try downloading manually: $url"
        return 1
    fi
}

# --- Create folder structure ---
echo -e "${CYAN}  Creating folder structure...${NC}"
mkdir -p "$PROJECT_ROOT/engines/llamafile"
mkdir -p "$PROJECT_ROOT/engines/koboldcpp"
mkdir -p "$PROJECT_ROOT/engines/whisperfile"
mkdir -p "$PROJECT_ROOT/models/primary"
mkdir -p "$PROJECT_ROOT/models/alternatives"
mkdir -p "$PROJECT_ROOT/models/specialized"
mkdir -p "$PROJECT_ROOT/models/mobile"
mkdir -p "$PROJECT_ROOT/knowledge/stackexchange"
mkdir -p "$PROJECT_ROOT/apps/kiwix"
mkdir -p "$PROJECT_ROOT/apps/veracrypt"
mkdir -p "$PROJECT_ROOT/apps/android"
echo -e "${GREEN}  [OK] Folder structure created${NC}"
echo ""

# --- Download llamafile ---
echo -e "${CYAN}  ========================================${NC}"
echo -e "${CYAN}  Step 1/4: AI Engine — llamafile v0.10.0${NC}"
echo -e "${CYAN}  ========================================${NC}"
download_file \
    "https://github.com/mozilla-ai/llamafile/releases/download/0.10.0/llamafile-0.10.0" \
    "$PROJECT_ROOT/engines/llamafile/llamafile-macos" \
    "llamafile v0.10.0 (AI inference engine)"

chmod +x "$PROJECT_ROOT/engines/llamafile/llamafile-macos" 2>/dev/null
xattr -dr com.apple.quarantine "$PROJECT_ROOT/engines/llamafile/llamafile-macos" 2>/dev/null

# --- Download KoboldCpp ---
echo ""
echo -e "${CYAN}  ========================================${NC}"
echo -e "${CYAN}  Step 2/4: AI Engine — KoboldCpp v1.110${NC}"
echo -e "${CYAN}  ========================================${NC}"

if [ "$IS_APPLE_SILICON" = true ]; then
    download_file \
        "https://github.com/LostRuins/koboldcpp/releases/download/v1.110/koboldcpp-mac-arm64" \
        "$PROJECT_ROOT/engines/koboldcpp/koboldcpp-mac-arm64" \
        "KoboldCpp v1.110 (macOS ARM64)"
    chmod +x "$PROJECT_ROOT/engines/koboldcpp/koboldcpp-mac-arm64" 2>/dev/null
    xattr -dr com.apple.quarantine "$PROJECT_ROOT/engines/koboldcpp/koboldcpp-mac-arm64" 2>/dev/null
else
    echo -e "${YELLOW}  [INFO] KoboldCpp does not have an Intel macOS build.${NC}"
    echo "  Use llamafile instead (it works on Intel Macs)."
fi

# --- Download AI Model ---
echo ""
echo -e "${CYAN}  ========================================${NC}"
echo -e "${CYAN}  Step 3/4: AI Model — $MODEL_NAME${NC}"
echo -e "${CYAN}  ========================================${NC}"
echo -e "${YELLOW}  This is the largest download ($MODEL_SIZE). Please be patient.${NC}"
echo -e "${YELLOW}  Aceasta este cea mai mare descarcare ($MODEL_SIZE). Va rugam asteptati.${NC}"
echo ""
download_file \
    "$MODEL_URL" \
    "$PROJECT_ROOT/models/$MODEL_FOLDER/$MODEL_FILE" \
    "$MODEL_NAME AI model ($MODEL_SIZE)"

# Also download mobile version
echo ""
echo -e "${CYAN}  Downloading mobile-optimized model for phones...${NC}"
download_file \
    "https://huggingface.co/bartowski/Qwen_Qwen3-4B-GGUF/resolve/main/Qwen_Qwen3-4B-Q3_K_M.gguf" \
    "$PROJECT_ROOT/models/mobile/qwen3-4b-q3_k_m.gguf" \
    "Qwen3-4B mobile (Q3_K_M, ~2 GB, for phones)"

# --- Kiwix note ---
echo ""
echo -e "${CYAN}  ========================================${NC}"
echo -e "${CYAN}  Step 4/4: Kiwix (Wikipedia Reader)${NC}"
echo -e "${CYAN}  ========================================${NC}"
echo -e "${YELLOW}  On macOS, install Kiwix from the App Store (free):${NC}"
echo "  Search 'Kiwix' in the App Store and install it."
echo "  Then open Kiwix → File → Open File → navigate to your SSD → knowledge/ → select a .zim file"
echo ""

# --- Remove quarantine from everything ---
echo -e "${CYAN}  Removing macOS quarantine flags from all binaries...${NC}"
xattr -dr com.apple.quarantine "$PROJECT_ROOT/engines/" 2>/dev/null
echo -e "${GREEN}  [OK] Quarantine flags removed${NC}"

# --- Summary ---
echo ""
echo -e "${GREEN}  ============================================${NC}"
echo -e "${GREEN}  SETUP COMPLETE!${NC}"
echo -e "${GREEN}  ============================================${NC}"
echo ""
echo "  What was installed:"
echo "    - llamafile v0.10.0 (AI engine)"
echo "    - KoboldCpp v1.110 (alternative AI engine)"
echo "    - $MODEL_NAME model ($MODEL_SIZE)"
echo "    - Qwen3-4B mobile model (for phones)"
echo ""
echo "  Next steps / Pasii urmatori:"
echo "    1. Download knowledge bases: ./setup/download-knowledge.sh"
echo "    2. Install Kiwix from App Store"
echo "    3. Launch AI: double-click launchers/start-macos.command"
echo "    4. Verify: ./tools/verify-setup.sh"
echo ""
echo -e "${GREEN}  Enjoy your portable offline AI! / Bucurati-va de AI-ul portabil offline!${NC}"
echo ""
