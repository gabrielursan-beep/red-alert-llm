#!/bin/bash
DIR="$(cd "$(dirname "$0")/.." && pwd)"
xattr -dr com.apple.quarantine "$DIR/engines/" 2>/dev/null

# Find best model
MODEL=""
[ -f "$DIR/models/primary/qwen3-14b-q4_k_m.gguf" ] && MODEL="$DIR/models/primary/qwen3-14b-q4_k_m.gguf"
[ -z "$MODEL" ] && [ -f "$DIR/models/primary/qwen3-8b-q4_k_m.gguf" ] && MODEL="$DIR/models/primary/qwen3-8b-q4_k_m.gguf"
[ -z "$MODEL" ] && [ -f "$DIR/models/primary/qwen3-4b-q4_k_m.gguf" ] && MODEL="$DIR/models/primary/qwen3-4b-q4_k_m.gguf"
[ -z "$MODEL" ] && [ -f "$DIR/models/alternatives/gemma-3-4b-it-q4_k_m.gguf" ] && MODEL="$DIR/models/alternatives/gemma-3-4b-it-q4_k_m.gguf"

if [ -z "$MODEL" ]; then
    echo "[ERROR] No model found! Run setup first."
    read -p "Press Enter..."
    exit 1
fi

KOBOLD="$DIR/engines/koboldcpp/koboldcpp-mac-arm64"
chmod +x "$KOBOLD" 2>/dev/null
echo "Starting KoboldCpp with: $(basename "$MODEL")"
"$KOBOLD" --model "$MODEL" --gpulayers 999 --contextsize 4096 --port 5001
read -p "Press Enter to exit..."
