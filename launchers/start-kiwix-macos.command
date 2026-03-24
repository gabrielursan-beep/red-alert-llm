#!/bin/bash
DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║  Kiwix — Wikipedia Offline               ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""
echo "  ZIM files are in: $DIR/knowledge/"
echo ""

# Try to open Kiwix
if open -a Kiwix 2>/dev/null; then
    echo "  Kiwix opened! / Kiwix deschis!"
    echo "  Go to File > Open File and navigate to:"
    echo "  Mergeti la File > Open File si navigati la:"
    echo "  $DIR/knowledge/"
else
    echo "  Kiwix is not installed. / Kiwix nu este instalat."
    echo ""
    echo "  Install from App Store: search 'Kiwix' (free)"
    echo "  Instalati din App Store: cautati 'Kiwix' (gratuit)"
fi

echo ""
read -p "  Press Enter to exit..."
