#!/bin/bash
# Red Alert LLM — Linux AI Assistant Launcher
DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║     RED ALERT LLM — AI Assistant         ║"
echo "  ║     Asistent AI Offline Portabil          ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""

# Detect RAM
RAM_KB=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}')
RAM_GB=$((RAM_KB / 1048576))
echo "  Detected RAM: ${RAM_GB} GB"
echo ""

# Select model
MODEL_PATH=""
MODEL_NAME=""

if [ $RAM_GB -ge 16 ] && [ -f "$DIR/models/primary/qwen3-14b-q4_k_m.gguf" ]; then
    MODEL_PATH="$DIR/models/primary/qwen3-14b-q4_k_m.gguf"
    MODEL_NAME="Qwen3-14B (Premium)"
elif [ $RAM_GB -ge 12 ] && [ -f "$DIR/models/primary/qwen3-8b-q4_k_m.gguf" ]; then
    MODEL_PATH="$DIR/models/primary/qwen3-8b-q4_k_m.gguf"
    MODEL_NAME="Qwen3-8B (Enhanced)"
elif [ $RAM_GB -ge 8 ] && [ -f "$DIR/models/primary/qwen3-4b-q4_k_m.gguf" ]; then
    MODEL_PATH="$DIR/models/primary/qwen3-4b-q4_k_m.gguf"
    MODEL_NAME="Qwen3-4B (Standard)"
elif [ -f "$DIR/models/alternatives/gemma-3-4b-it-q4_k_m.gguf" ]; then
    MODEL_PATH="$DIR/models/alternatives/gemma-3-4b-it-q4_k_m.gguf"
    MODEL_NAME="Gemma-3-4B (Lightweight)"
fi

if [ -z "$MODEL_PATH" ]; then
    echo "  [ERROR] No model found! Run setup first: ./setup/setup-mac.sh"
    exit 1
fi

echo "  Model: $MODEL_NAME"
echo "  Browser: http://localhost:8080"
echo ""

# Check for NVIDIA GPU
GPU_FLAGS=""
if command -v nvidia-smi &>/dev/null; then
    echo "  NVIDIA GPU detected — CUDA acceleration enabled"
    GPU_FLAGS="-ngl 999"
fi

LLAMAFILE="$DIR/engines/llamafile/llamafile-linux"
chmod +x "$LLAMAFILE" 2>/dev/null

(sleep 5 && xdg-open "http://localhost:8080" 2>/dev/null) &

"$LLAMAFILE" -m "$MODEL_PATH" --host 127.0.0.1 --port 8080 -c 4096 $GPU_FLAGS
