#!/bin/bash
# ============================================================
# Red Alert LLM — Linux Setup Script
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${RED}  RED ALERT LLM — Setup for Linux${NC}"
echo ""

# Detect RAM
RAM_KB=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}')
RAM_GB=$((RAM_KB / 1048576))
echo -e "${GREEN}  Detected RAM: ${RAM_GB} GB${NC}"

# Select model
if [ $RAM_GB -ge 16 ]; then
    MODEL_FILE="qwen3-14b-q4_k_m.gguf"
    MODEL_URL="https://huggingface.co/bartowski/Qwen_Qwen3-14B-GGUF/resolve/main/Qwen_Qwen3-14B-Q4_K_M.gguf"
    MODEL_SIZE="9 GB"; MODEL_FOLDER="primary"
elif [ $RAM_GB -ge 12 ]; then
    MODEL_FILE="qwen3-8b-q4_k_m.gguf"
    MODEL_URL="https://huggingface.co/bartowski/Qwen_Qwen3-8B-GGUF/resolve/main/Qwen_Qwen3-8B-Q4_K_M.gguf"
    MODEL_SIZE="5 GB"; MODEL_FOLDER="primary"
elif [ $RAM_GB -ge 8 ]; then
    MODEL_FILE="qwen3-4b-q4_k_m.gguf"
    MODEL_URL="https://huggingface.co/bartowski/Qwen_Qwen3-4B-GGUF/resolve/main/Qwen_Qwen3-4B-Q4_K_M.gguf"
    MODEL_SIZE="2.5 GB"; MODEL_FOLDER="primary"
else
    MODEL_FILE="gemma-3-4b-it-q4_k_m.gguf"
    MODEL_URL="https://huggingface.co/ggml-org/gemma-3-4b-it-GGUF/resolve/main/gemma-3-4b-it-Q4_K_M.gguf"
    MODEL_SIZE="2.5 GB"; MODEL_FOLDER="alternatives"
fi

echo -e "${GREEN}  Selected model: $MODEL_FILE ($MODEL_SIZE)${NC}"
echo ""

# Create folders
mkdir -p "$PROJECT_ROOT/engines/llamafile" "$PROJECT_ROOT/engines/koboldcpp"
mkdir -p "$PROJECT_ROOT/models/primary" "$PROJECT_ROOT/models/alternatives" "$PROJECT_ROOT/models/mobile"
mkdir -p "$PROJECT_ROOT/knowledge/stackexchange"
mkdir -p "$PROJECT_ROOT/apps/kiwix" "$PROJECT_ROOT/apps/android"

# Download function
download() {
    local url="$1" dest="$2" desc="$3"
    if [ -f "$dest" ] && [ $(stat -c%s "$dest" 2>/dev/null || echo 0) -gt 1048576 ]; then
        echo -e "${YELLOW}  [SKIP] $desc already exists${NC}"
        return 0
    fi
    echo -e "${CYAN}  [DOWNLOAD] $desc${NC}"
    mkdir -p "$(dirname "$dest")"
    curl -L -# -C - -o "$dest" "$url" && echo -e "${GREEN}  [OK] $desc${NC}" || echo -e "${RED}  [FAIL] $desc${NC}"
}

# Download engines
echo -e "${CYAN}  Step 1: llamafile${NC}"
download "https://github.com/mozilla-ai/llamafile/releases/download/0.10.0/llamafile-0.10.0" \
    "$PROJECT_ROOT/engines/llamafile/llamafile-linux" "llamafile v0.10.0"
chmod +x "$PROJECT_ROOT/engines/llamafile/llamafile-linux" 2>/dev/null

echo ""
echo -e "${CYAN}  Step 2: KoboldCpp${NC}"
download "https://github.com/LostRuins/koboldcpp/releases/download/v1.110/koboldcpp-linux-x64-nocuda" \
    "$PROJECT_ROOT/engines/koboldcpp/koboldcpp-linux-x64-nocuda" "KoboldCpp v1.110"
chmod +x "$PROJECT_ROOT/engines/koboldcpp/koboldcpp-linux-x64-nocuda" 2>/dev/null

echo ""
echo -e "${CYAN}  Step 3: AI Model ($MODEL_SIZE)${NC}"
download "$MODEL_URL" "$PROJECT_ROOT/models/$MODEL_FOLDER/$MODEL_FILE" "$MODEL_FILE"

echo ""
echo -e "${CYAN}  Step 4: Mobile model${NC}"
download "https://huggingface.co/bartowski/Qwen_Qwen3-4B-GGUF/resolve/main/Qwen_Qwen3-4B-Q3_K_M.gguf" \
    "$PROJECT_ROOT/models/mobile/qwen3-4b-q3_k_m.gguf" "Qwen3-4B mobile"

echo ""
echo -e "${GREEN}  SETUP COMPLETE!${NC}"
echo "  Next: ./setup/download-knowledge.sh"
echo "  Launch: ./launchers/start-linux.sh"
echo ""
