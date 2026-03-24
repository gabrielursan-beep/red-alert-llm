#!/bin/bash
# Red Alert LLM — Setup Verification (macOS/Linux)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║  Red Alert LLM — Setup Verification      ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""

# --- AI Engines ---
echo "  [AI ENGINES]"

if [ -f "$PROJECT_ROOT/engines/llamafile/llamafile-macos" ]; then
    echo -e "    ${GREEN}[PASS]${NC} llamafile-macos found"
    PASS=$((PASS + 1))
elif [ -f "$PROJECT_ROOT/engines/llamafile/llamafile-linux" ]; then
    echo -e "    ${GREEN}[PASS]${NC} llamafile-linux found"
    PASS=$((PASS + 1))
else
    echo -e "    ${RED}[FAIL]${NC} llamafile MISSING"
    FAIL=$((FAIL + 1))
fi

if [ -f "$PROJECT_ROOT/engines/koboldcpp/koboldcpp-mac-arm64" ] || [ -f "$PROJECT_ROOT/engines/koboldcpp/koboldcpp-linux-x64-nocuda" ]; then
    echo -e "    ${GREEN}[PASS]${NC} KoboldCpp found"
    PASS=$((PASS + 1))
else
    echo -e "    ${YELLOW}[WARN]${NC} KoboldCpp missing (optional)"
    WARN=$((WARN + 1))
fi
echo ""

# --- AI Models ---
echo "  [AI MODELS]"

MODEL_FOUND=0
for model in qwen3-4b-q4_k_m.gguf qwen3-8b-q4_k_m.gguf qwen3-14b-q4_k_m.gguf; do
    if [ -f "$PROJECT_ROOT/models/primary/$model" ]; then
        SIZE_MB=$(( $(stat -f%z "$PROJECT_ROOT/models/primary/$model" 2>/dev/null || stat -c%s "$PROJECT_ROOT/models/primary/$model" 2>/dev/null || echo 0) / 1048576 ))
        echo -e "    ${GREEN}[PASS]${NC} $model (${SIZE_MB} MB)"
        PASS=$((PASS + 1))
        MODEL_FOUND=1
    fi
done

for model in gemma-3-4b-it-q4_k_m.gguf gemma-3-12b-it-q4_k_m.gguf; do
    if [ -f "$PROJECT_ROOT/models/alternatives/$model" ]; then
        echo -e "    ${GREEN}[PASS]${NC} $model"
        PASS=$((PASS + 1))
        MODEL_FOUND=1
    fi
done

if [ $MODEL_FOUND -eq 0 ]; then
    echo -e "    ${RED}[FAIL]${NC} No AI model found! Run setup first."
    FAIL=$((FAIL + 1))
fi

if [ -f "$PROJECT_ROOT/models/mobile/qwen3-4b-q3_k_m.gguf" ]; then
    echo -e "    ${GREEN}[PASS]${NC} Mobile model found"
    PASS=$((PASS + 1))
else
    echo -e "    ${YELLOW}[WARN]${NC} Mobile model missing (for phones)"
    WARN=$((WARN + 1))
fi
echo ""

# --- Knowledge Bases ---
echo "  [KNOWLEDGE BASES]"

ZIM_COUNT=$(find "$PROJECT_ROOT/knowledge" -name "*.zim" 2>/dev/null | wc -l | tr -d ' ')
if [ "$ZIM_COUNT" -gt 0 ]; then
    echo -e "    ${GREEN}[PASS]${NC} $ZIM_COUNT ZIM file(s) found"
    PASS=$((PASS + 1))

    # List them
    find "$PROJECT_ROOT/knowledge" -name "*.zim" -exec basename {} \; 2>/dev/null | while read f; do
        echo "           - $f"
    done
else
    echo -e "    ${YELLOW}[WARN]${NC} No ZIM files found. Run: ./setup/download-knowledge.sh"
    WARN=$((WARN + 1))
fi
echo ""

# --- Config ---
echo "  [CONFIG]"

if [ -f "$PROJECT_ROOT/config/models.json" ]; then
    echo -e "    ${GREEN}[PASS]${NC} models.json"
    PASS=$((PASS + 1))
else
    echo -e "    ${RED}[FAIL]${NC} models.json MISSING"
    FAIL=$((FAIL + 1))
fi

if [ -f "$PROJECT_ROOT/config/knowledge.json" ]; then
    echo -e "    ${GREEN}[PASS]${NC} knowledge.json"
    PASS=$((PASS + 1))
else
    echo -e "    ${RED}[FAIL]${NC} knowledge.json MISSING"
    FAIL=$((FAIL + 1))
fi
echo ""

# --- Summary ---
echo "  ============================================"
echo "   RESULTS: $PASS PASS / $FAIL FAIL / $WARN WARN"
echo "  ============================================"

if [ $FAIL -eq 0 ]; then
    echo ""
    echo -e "  ${GREEN}Setup is READY!${NC}"
    echo "  Launch with: ./launchers/start-macos.command (or start-linux.sh)"
else
    echo ""
    echo -e "  ${RED}Some components are missing.${NC} Run setup first."
fi
echo ""
