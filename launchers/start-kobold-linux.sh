#!/bin/bash
# Red Alert LLM — KoboldCpp Linux Launcher
DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Detect RAM
RAM_KB=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}')
RAM_GB=$((RAM_KB / 1048576))

# Select model based on RAM
MODEL=""
MODEL_NAME=""

if [ $RAM_GB -ge 16 ] && [ -f "$DIR/models/primary/qwen3-14b-q4_k_m.gguf" ]; then
    MODEL="$DIR/models/primary/qwen3-14b-q4_k_m.gguf"
    MODEL_NAME="Qwen3-14B (Premium)"
elif [ $RAM_GB -ge 12 ] && [ -f "$DIR/models/primary/qwen3-8b-q4_k_m.gguf" ]; then
    MODEL="$DIR/models/primary/qwen3-8b-q4_k_m.gguf"
    MODEL_NAME="Qwen3-8B (Enhanced)"
elif [ -f "$DIR/models/primary/qwen3-4b-q4_k_m.gguf" ]; then
    MODEL="$DIR/models/primary/qwen3-4b-q4_k_m.gguf"
    MODEL_NAME="Qwen3-4B (Standard)"
elif [ -f "$DIR/models/alternatives/gemma-3-4b-it-q4_k_m.gguf" ]; then
    MODEL="$DIR/models/alternatives/gemma-3-4b-it-q4_k_m.gguf"
    MODEL_NAME="Gemma-3-4B (Lightweight)"
fi

if [ -z "$MODEL" ]; then
    echo "[ERROR] No model found! Run setup first: ./setup/setup-linux.sh"
    exit 1
fi

KOBOLD="$DIR/engines/koboldcpp/koboldcpp-linux-x64-nocuda"
chmod +x "$KOBOLD" 2>/dev/null

# Check for NVIDIA GPU
GPU_FLAGS=""
if command -v nvidia-smi &>/dev/null; then
    echo "  NVIDIA GPU detected — CUDA acceleration enabled"
    GPU_FLAGS="--gpulayers 999"
fi

echo ""
echo "  Starting KoboldCpp with: $MODEL_NAME (${RAM_GB} GB RAM)"
echo ""
"$KOBOLD" --model "$MODEL" --host 127.0.0.1 $GPU_FLAGS --contextsize 4096 --port 5001
