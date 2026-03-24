#!/bin/bash
# ============================================================
# Red Alert LLM — Knowledge Base Download Script
# ============================================================
# Interactive ZIM file downloader.
# Works on macOS, Linux, Git Bash (Windows), WSL.
# Supports resume for interrupted downloads.
# Usage: chmod +x setup/download-knowledge.sh && ./setup/download-knowledge.sh
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ZIM_DIR="$PROJECT_ROOT/knowledge"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${RED}  ============================================${NC}"
echo -e "${RED}  RED ALERT LLM — Knowledge Base Download${NC}"
echo -e "${RED}  ============================================${NC}"
echo ""
echo "  This script downloads offline knowledge bases (ZIM files)."
echo "  Acest script descarca baze de cunostinte offline (fisiere ZIM)."
echo ""
echo "  Downloads go to: $ZIM_DIR"
echo ""

# --- Check curl ---
if ! command -v curl &> /dev/null; then
    echo -e "${RED}  [ERROR] curl is not installed. Please install curl first.${NC}"
    exit 1
fi

mkdir -p "$ZIM_DIR"
mkdir -p "$ZIM_DIR/stackexchange"

# --- Knowledge base definitions ---
# Format: ID|NAME|URL|SIZE_GB|DEST_SUBDIR
KNOWLEDGE_BASES=(
    "1|Wikipedia EN (full, images) — 115 GB|https://download.kiwix.org/zim/wikipedia/wikipedia_en_all_maxi_2026-02.zim|115|."
    "2|Wikipedia EN (text only) — 48 GB|https://download.kiwix.org/zim/wikipedia/wikipedia_en_all_nopic_2025-12.zim|48|."
    "3|Wikipedia RO (full, images) — 10.6 GB|https://download.kiwix.org/zim/wikipedia/wikipedia_ro_all_maxi_2026-02.zim|10.6|."
    "4|Wikipedia RO (text only) — 2.3 GB|https://download.kiwix.org/zim/wikipedia/wikipedia_ro_all_nopic_2026-02.zim|2.3|."
    "5|WikiMed Medical Encyclopedia — 2.1 GB|https://download.kiwix.org/zim/other/mdwiki_en_all_maxi_2025-11.zim|2.1|."
    "6|iFixit Repair Guides — 3.3 GB|https://download.kiwix.org/zim/ifixit/ifixit_en_all_2025-12.zim|3.3|."
    "7|Wiktionary EN (dictionary) — 8.2 GB|https://download.kiwix.org/zim/wiktionary/wiktionary_en_all_nopic_2026-02.zim|8.2|."
    "8|Wikivoyage (travel guides) — 1 GB|https://download.kiwix.org/zim/wikivoyage/wikivoyage_en_all_maxi_2026-03.zim|1|."
    "9|SuperUser Q&A — 3.7 GB|https://download.kiwix.org/zim/stack_exchange/superuser.com_en_all_2026-02.zim|3.7|stackexchange"
    "10|DIY Home Repair Q&A — 1.9 GB|https://download.kiwix.org/zim/stack_exchange/diy.stackexchange.com_en_all_2026-02.zim|1.9|stackexchange"
    "11|Electronics Q&A — 3.9 GB|https://download.kiwix.org/zim/stack_exchange/electronics.stackexchange.com_en_all_2026-02.zim|3.9|stackexchange"
    "12|Wikibooks EN (textbooks) — 2 GB|https://download.kiwix.org/zim/wikibooks/wikibooks_en_all_maxi_2026-02.zim|2|."
)

# --- Install profiles ---
echo -e "${BOLD}  Choose an install profile / Alegeti un profil de instalare:${NC}"
echo ""
echo -e "    ${CYAN}[M]${NC} Minimal  — ~55 GB  (Wikipedia EN text + RO text + WikiMed)"
echo -e "    ${CYAN}[R]${NC} Recommended — ~80 GB  (+ iFixit, Wiktionary, Wikivoyage, SuperUser)"
echo -e "    ${CYAN}[F]${NC} Full     — ~200 GB (Everything including full Wikipedia with images)"
echo -e "    ${CYAN}[C]${NC} Custom   — Choose individual downloads"
echo ""
read -p "  Your choice / Alegerea dvs [M/R/F/C]: " PROFILE

case "${PROFILE^^}" in
    M)
        SELECTED="2 4 5"
        echo -e "${GREEN}  Minimal profile selected (~55 GB)${NC}"
        ;;
    R)
        SELECTED="2 3 5 6 7 8 9"
        echo -e "${GREEN}  Recommended profile selected (~80 GB)${NC}"
        ;;
    F)
        SELECTED="1 2 3 4 5 6 7 8 9 10 11 12"
        echo -e "${GREEN}  Full profile selected (~200 GB)${NC}"
        ;;
    C)
        echo ""
        echo "  Available knowledge bases / Baze de cunostinte disponibile:"
        echo ""
        for kb in "${KNOWLEDGE_BASES[@]}"; do
            IFS='|' read -r id name url size dest <<< "$kb"
            echo -e "    ${CYAN}[$id]${NC} $name"
        done
        echo ""
        read -p "  Enter numbers separated by spaces (e.g., 1 3 5): " SELECTED
        ;;
    *)
        echo -e "${RED}  Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac

echo ""

# --- Calculate total size ---
TOTAL_SIZE=0
for sel in $SELECTED; do
    for kb in "${KNOWLEDGE_BASES[@]}"; do
        IFS='|' read -r id name url size dest <<< "$kb"
        if [ "$id" = "$sel" ]; then
            TOTAL_SIZE=$(echo "$TOTAL_SIZE + $size" | bc 2>/dev/null || echo "$TOTAL_SIZE")
        fi
    done
done

echo -e "${YELLOW}  Total download size: ~${TOTAL_SIZE} GB${NC}"
echo -e "${YELLOW}  Make sure you have enough space on the SSD.${NC}"
echo ""
read -p "  Continue? / Continuati? [Y/n]: " CONFIRM
if [ "${CONFIRM,,}" = "n" ]; then
    echo "  Cancelled. / Anulat."
    exit 0
fi

echo ""

# --- Download selected knowledge bases ---
DOWNLOADED=0
FAILED=0

for sel in $SELECTED; do
    for kb in "${KNOWLEDGE_BASES[@]}"; do
        IFS='|' read -r id name url size dest <<< "$kb"
        if [ "$id" = "$sel" ]; then
            echo -e "${CYAN}  ────────────────────────────────────────${NC}"
            echo -e "${CYAN}  Downloading: $name${NC}"
            echo "  URL: $url"

            FILENAME=$(basename "$url")
            if [ "$dest" = "." ]; then
                DEST_PATH="$ZIM_DIR/$FILENAME"
            else
                DEST_PATH="$ZIM_DIR/$dest/$FILENAME"
            fi

            # Check if already exists
            if [ -f "$DEST_PATH" ]; then
                EXISTING_SIZE=$(stat -f%z "$DEST_PATH" 2>/dev/null || stat -c%s "$DEST_PATH" 2>/dev/null || echo 0)
                EXISTING_MB=$((EXISTING_SIZE / 1048576))
                echo -e "${YELLOW}  [EXISTS] File already exists (${EXISTING_MB} MB). Resuming if incomplete...${NC}"
            fi

            # Download with resume support
            if curl -L -# -C - -o "$DEST_PATH" "$url"; then
                echo -e "${GREEN}  [OK] Downloaded successfully${NC}"
                DOWNLOADED=$((DOWNLOADED + 1))
            else
                echo -e "${RED}  [ERROR] Download failed. You can re-run this script to resume.${NC}"
                FAILED=$((FAILED + 1))
            fi
            echo ""
        fi
    done
done

# --- Summary ---
echo -e "${GREEN}  ============================================${NC}"
echo -e "${GREEN}  DOWNLOAD COMPLETE!${NC}"
echo -e "${GREEN}  ============================================${NC}"
echo ""
echo "  Downloaded: $DOWNLOADED files"
if [ $FAILED -gt 0 ]; then
    echo -e "  ${RED}Failed: $FAILED files (re-run script to retry)${NC}"
fi
echo ""
echo "  To use Wikipedia offline:"
echo "    - Windows: double-click launchers/start-kiwix-windows.bat"
echo "    - macOS: open Kiwix app, File > Open, select a .zim file"
echo "    - Android: open Kiwix APK, browse to knowledge/ folder"
echo ""
echo -e "${GREEN}  Your offline knowledge base is ready!${NC}"
echo ""
