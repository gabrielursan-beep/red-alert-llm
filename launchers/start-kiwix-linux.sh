#!/bin/bash
DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo ""
echo "  Kiwix — Wikipedia Offline"
echo ""

KIWIX_APP="$DIR/apps/kiwix/kiwix-linux.appimage"
if [ -f "$KIWIX_APP" ]; then
    chmod +x "$KIWIX_APP"
    echo "  Starting Kiwix... ZIM files in: $DIR/knowledge/"
    "$KIWIX_APP" &
else
    echo "  Kiwix AppImage not found."
    echo "  Download from: https://kiwix.org/en/applications/"
    echo "  Save to: $DIR/apps/kiwix/kiwix-linux.appimage"
    echo ""
    echo "  ZIM files are in: $DIR/knowledge/"
fi
