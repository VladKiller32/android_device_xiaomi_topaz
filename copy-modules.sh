#!/usr/bin/env bash
# Copy stock GKI 5.15 kernel modules from a dumpyara firmware dump into prebuilts/modules/
# Usage: ./copy-modules.sh /path/to/dumpyara/dump

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 /path/to/dumpyara/dump"
    exit 1
fi

DUMP_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -d "$DUMP_DIR/vendor_boot/ramdisk/lib/modules" || ! -d "$DUMP_DIR/vendor_dlkm/lib/modules" ]]; then
    echo "Error: expected vendor_boot and vendor_dlkm module directories under '$DUMP_DIR'"
    exit 1
fi

mkdir -p "$SCRIPT_DIR/prebuilts/modules/vendor_boot" "$SCRIPT_DIR/prebuilts/modules/vendor_dlkm"
cp -v "$DUMP_DIR/vendor_boot/ramdisk/lib/modules/"*.ko "$SCRIPT_DIR/prebuilts/modules/vendor_boot/"
cp -v "$DUMP_DIR/vendor_boot/ramdisk/lib/modules/modules.load" "$SCRIPT_DIR/prebuilts/modules/vendor_boot/"
cp -v "$DUMP_DIR/vendor_dlkm/lib/modules/"*.ko "$SCRIPT_DIR/prebuilts/modules/vendor_dlkm/"
cp -v "$DUMP_DIR/vendor_dlkm/lib/modules/modules.load" "$SCRIPT_DIR/prebuilts/modules/vendor_dlkm/"

echo "Done! Prebuilt GKI modules copied into prebuilts/modules/."
