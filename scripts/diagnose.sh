#!/usr/bin/env sh
set -eu

PREFIX="${EOP_WINEPREFIX:-"$HOME/.local/share/everyone-piano-linux/wineprefix"}"
WINE_BIN="${WINE_BIN:-wine}"

section() {
  printf '\n== %s ==\n' "$1"
}

section "System"
uname -a || true

section "Wine"
if command -v "$WINE_BIN" >/dev/null 2>&1; then
  command -v "$WINE_BIN"
  "$WINE_BIN" --version || true
else
  echo "wine not found"
fi

section "Prefix"
echo "$PREFIX"
if [ -f "$PREFIX/system.reg" ]; then
  grep '^#arch=' "$PREFIX/system.reg" || true
else
  echo "prefix not found"
fi

section "Configured Windows Version"
if command -v "$WINE_BIN" >/dev/null 2>&1 && [ -d "$PREFIX" ]; then
  WINEPREFIX="$PREFIX" "$WINE_BIN" reg query 'HKCU\Software\Wine' /v Version || true
fi

section "Everyone Piano Executable"
for path in \
  "$PREFIX/drive_c/Program Files/EveryonePiano/EveryonePiano.exe" \
  "$PREFIX/drive_c/Program Files (x86)/EveryonePiano/EveryonePiano.exe"
do
  if [ -f "$path" ]; then
    echo "$path"
  fi
done

section "Running Processes"
pgrep -af 'EveryonePiano|everyonepiano|winedbg|wineserver|wine' || true

section "Windows"
if command -v wmctrl >/dev/null 2>&1; then
  wmctrl -lx | grep -i 'everyonepiano\|winedbg\|wine' || true
else
  echo "wmctrl not installed"
fi

section "Audio Streams"
if command -v pactl >/dev/null 2>&1; then
  pactl list sink-inputs | grep -E 'Sink Input|application.name|application.process.binary|media.name' || true
else
  echo "pactl not installed"
fi

