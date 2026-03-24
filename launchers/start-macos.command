#!/bin/bash
# ============================================================
# Red Alert LLM — macOS AI Assistant Launcher
# ============================================================
# Double-click this file in Finder to launch the AI assistant.
# ============================================================

DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║     RED ALERT LLM — AI Assistant         ║"
echo "  ║     Asistent AI Offline Portabil          ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""

# --- Remove quarantine flags ---
xattr -dr com.apple.quarantine "$DIR/engines/" 2>/dev/null

# --- Detect RAM ---
RAM_BYTES=$(sysctl -n hw.memsize 2>/dev/null || echo 8589934592)
RAM_GB=$((RAM_BYTES / 1073741824))
echo "  Detected RAM / RAM detectat: ${RAM_GB} GB"

# --- Detect Apple Silicon ---
ARCH=$(uname -m)
GPU_FLAGS=""
if [ "$ARCH" = "arm64" ]; then
    echo "  Apple Silicon detected — Metal GPU acceleration enabled"
    GPU_FLAGS="-ngl 999"
else
    echo "  Intel Mac detected — CPU only (no GPU acceleration)"
fi
echo ""

# --- Select model based on RAM ---
MODEL_PATH=""
MODEL_NAME=""

if [ $RAM_GB -ge 16 ] && [ -f "$DIR/models/primary/qwen3-14b-q4_k_m.gguf" ]; then
    MODEL_PATH="$DIR/models/primary/qwen3-14b-q4_k_m.gguf"
    MODEL_NAME="Qwen3-14B (Premium, 9 GB)"
elif [ $RAM_GB -ge 12 ] && [ -f "$DIR/models/primary/qwen3-8b-q4_k_m.gguf" ]; then
    MODEL_PATH="$DIR/models/primary/qwen3-8b-q4_k_m.gguf"
    MODEL_NAME="Qwen3-8B (Enhanced, 5 GB)"
elif [ $RAM_GB -ge 8 ] && [ -f "$DIR/models/primary/qwen3-4b-q4_k_m.gguf" ]; then
    MODEL_PATH="$DIR/models/primary/qwen3-4b-q4_k_m.gguf"
    MODEL_NAME="Qwen3-4B (Standard, 2.5 GB)"
elif [ -f "$DIR/models/alternatives/gemma-3-4b-it-q4_k_m.gguf" ]; then
    MODEL_PATH="$DIR/models/alternatives/gemma-3-4b-it-q4_k_m.gguf"
    MODEL_NAME="Gemma-3-4B (Lightweight, 2.5 GB)"
fi

if [ -z "$MODEL_PATH" ]; then
    echo "  [ERROR] No AI model found! / Nu s-a gasit niciun model AI!"
    echo "  Run setup first: ./setup/setup-mac.sh"
    echo ""
    read -p "  Press Enter to exit..."
    exit 1
fi

echo "  Model selected / Model selectat: $MODEL_NAME"
echo ""

# --- Choose engine ---
echo "  Choose AI engine / Alegeti motorul AI:"
echo "    1. llamafile (simplu, recomandat / simple, recommended)"
echo "    2. KoboldCpp (interfata mai bogata / richer interface)"
echo ""
read -p "  Type 1 or 2 / Tastati 1 sau 2: " choice

if [ "$choice" = "2" ]; then
    # KoboldCpp
    echo ""
    echo "  Starting KoboldCpp... / Se porneste KoboldCpp..."
    echo "  Loading model: $MODEL_NAME"
    echo ""

    KOBOLD="$DIR/engines/koboldcpp/koboldcpp-mac-arm64"
    chmod +x "$KOBOLD" 2>/dev/null

    if [ ! -f "$KOBOLD" ]; then
        echo "  [ERROR] KoboldCpp not found. Use llamafile instead (option 1)."
        read -p "  Press Enter to exit..."
        exit 1
    fi

    "$KOBOLD" --model "$MODEL_PATH" --host 127.0.0.1 --gpulayers 999 --contextsize 4096 --port 5001
else
    # llamafile
    echo ""
    echo "  Starting llamafile... / Se porneste llamafile..."
    echo "  Loading model: $MODEL_NAME"
    echo ""
    echo "  ┌────────────────────────────────────────────┐"
    echo "  │  Open browser at / Deschideti browserul:   │"
    echo "  │  http://localhost:8080                      │"
    echo "  │                                             │"
    echo "  │  To stop / Pentru oprire: Ctrl+C            │"
    echo "  └────────────────────────────────────────────┘"
    echo ""

    LLAMAFILE="$DIR/engines/llamafile/llamafile-macos"
    chmod +x "$LLAMAFILE" 2>/dev/null

    # Auto-open browser after 5 seconds
    (sleep 5 && open "http://localhost:8080") &

    "$LLAMAFILE" -m "$MODEL_PATH" --host 127.0.0.1 --port 8080 -c 4096 $GPU_FLAGS
fi

echo ""
echo "  AI server stopped. / Serverul AI s-a oprit."
read -p "  Press Enter to exit..."
