#!/usr/bin/env sh
set -eu

PREFIX="${EOP_WINEPREFIX:-"$HOME/.local/share/everyone-piano-linux/wineprefix"}"
WINE_BIN="${WINE_BIN:-wine}"

APP_EXE="${EOP_EXE:-"$PREFIX/drive_c/Program Files/EveryonePiano/EveryonePiano.exe"}"
if [ ! -f "$APP_EXE" ]; then
  APP_EXE="$PREFIX/drive_c/Program Files (x86)/EveryonePiano/EveryonePiano.exe"
fi

if ! command -v "$WINE_BIN" >/dev/null 2>&1; then
  echo "wine was not found. Install Wine first: https://www.winehq.org/download" >&2
  exit 1
fi

if [ ! -f "$APP_EXE" ]; then
  echo "EveryonePiano.exe was not found in: $PREFIX" >&2
  echo "Run scripts/install.sh with the official installer first." >&2
  exit 1
fi

export WINEPREFIX="$PREFIX"
exec "$WINE_BIN" start /unix "$APP_EXE"

