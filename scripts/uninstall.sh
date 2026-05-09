#!/usr/bin/env sh
set -eu

PROJECT_NAME="everyone-piano-linux"
PREFIX="${EOP_WINEPREFIX:-"$HOME/.local/share/$PROJECT_NAME/wineprefix"}"
LAUNCHER="$HOME/.local/bin/everyone-piano-linux"
DESKTOP_FILE="${XDG_DATA_HOME:-"$HOME/.local/share"}/applications/everyone-piano-linux.desktop"

if [ "${1:-}" != "--yes" ]; then
  cat <<EOF
This will remove:
  $PREFIX
  $LAUNCHER
  $DESKTOP_FILE

Re-run with --yes to continue.
EOF
  exit 2
fi

if command -v wineserver >/dev/null 2>&1; then
  WINEPREFIX="$PREFIX" wineserver -k >/dev/null 2>&1 || true
fi

rm -rf "$PREFIX"
rm -f "$LAUNCHER"
rm -f "$DESKTOP_FILE"

echo "Removed Everyone Piano Linux files."

