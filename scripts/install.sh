#!/usr/bin/env sh
set -eu

PROJECT_NAME="everyone-piano-linux"
OFFICIAL_DOWNLOAD_PAGE="https://www.everyonepiano.com/download.html"
WINE_DOWNLOAD_PAGE="https://www.winehq.org/download"

PREFIX="${EOP_WINEPREFIX:-"$HOME/.local/share/$PROJECT_NAME/wineprefix"}"
CACHE_DIR="${XDG_CACHE_HOME:-"$HOME/.cache"}/$PROJECT_NAME"
BIN_DIR="${HOME}/.local/bin"
APP_DIR="$PREFIX/drive_c/Program Files/EveryonePiano"
APP_EXE="$APP_DIR/EveryonePiano.exe"
DESKTOP_DIR="${XDG_DATA_HOME:-"$HOME/.local/share"}/applications"
DESKTOP_FILE="$DESKTOP_DIR/everyone-piano-linux.desktop"
LAUNCHER="$BIN_DIR/everyone-piano-linux"

usage() {
  cat <<EOF
Usage:
  scripts/install.sh /path/to/EveryonePiano_setup.exe
  scripts/install.sh /path/to/EveryonePiano_setup.zip
  scripts/install.sh https://example.com/EveryonePiano_setup.exe

Official Everyone Piano download page:
  $OFFICIAL_DOWNLOAD_PAGE

Wine download/install page:
  $WINE_DOWNLOAD_PAGE

Environment:
  EOP_WINEPREFIX  Wine prefix path. Default: $PREFIX
  WINE_BIN        Wine command. Default: wine
EOF
}

die() {
  echo "error: $*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "$1 was not found"
}

INSTALLER="${1:-}"
case "$INSTALLER" in
  -h|--help)
    usage
    exit 0
    ;;
  "")
    usage
    exit 2
    ;;
esac

WINE_BIN="${WINE_BIN:-wine}"
WINE_BIN_PATH="$(command -v "$WINE_BIN" 2>/dev/null || true)"
[ -n "$WINE_BIN_PATH" ] || die "Wine was not found. Install it from $WINE_DOWNLOAD_PAGE"
require_cmd wineboot
require_cmd winecfg
require_cmd wineserver

TMP_DIR=""
cleanup() {
  if [ -n "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
  fi
}
trap cleanup EXIT INT TERM

case "$INSTALLER" in
  http://*|https://*)
    require_cmd curl
    mkdir -p "$CACHE_DIR"
    BASENAME="${INSTALLER##*/}"
    [ -n "$BASENAME" ] || BASENAME="EveryonePiano_setup.exe"
    DOWNLOADED="$CACHE_DIR/$BASENAME"
    echo "Downloading installer to $DOWNLOADED"
    curl -L --fail -o "$DOWNLOADED" "$INSTALLER"
    INSTALLER="$DOWNLOADED"
    ;;
esac

[ -f "$INSTALLER" ] || die "installer not found: $INSTALLER"

case "$INSTALLER" in
  *.zip|*.ZIP)
    require_cmd unzip
    TMP_DIR="$(mktemp -d)"
    unzip -q "$INSTALLER" -d "$TMP_DIR"
    FOUND_INSTALLER="$(find "$TMP_DIR" -type f \( -iname '*setup*.exe' -o -iname '*.exe' \) | head -n 1)"
    [ -n "$FOUND_INSTALLER" ] || die "no .exe installer found inside zip"
    INSTALLER="$FOUND_INSTALLER"
    ;;
esac

if [ -f "$PREFIX/system.reg" ] && ! grep -q '^#arch=win32' "$PREFIX/system.reg"; then
  die "existing prefix is not 32-bit: $PREFIX"
fi

mkdir -p "$PREFIX"
echo "Creating/updating 32-bit Wine prefix: $PREFIX"
WINEPREFIX="$PREFIX" WINEARCH=win32 wineboot -u

echo "Setting Wine Windows version to Windows XP for Everyone Piano compatibility"
WINEPREFIX="$PREFIX" winecfg -v winxp
WINEPREFIX="$PREFIX" "$WINE_BIN_PATH" reg add 'HKCU\Software\Wine' /v Version /t REG_SZ /d winxp /f >/dev/null

echo "Installing Everyone Piano"
WINEPREFIX="$PREFIX" "$WINE_BIN_PATH" "$INSTALLER" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART

if [ ! -f "$APP_EXE" ]; then
  APP_EXE="$PREFIX/drive_c/Program Files (x86)/EveryonePiano/EveryonePiano.exe"
fi
[ -f "$APP_EXE" ] || die "installation finished, but EveryonePiano.exe was not found"

mkdir -p "$BIN_DIR" "$DESKTOP_DIR"

cat > "$LAUNCHER" <<EOF
#!/usr/bin/env sh
set -eu
export WINEPREFIX="$PREFIX"
exec "$WINE_BIN_PATH" start /unix "$APP_EXE"
EOF
chmod +x "$LAUNCHER"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Everyone Piano
Comment=Run Everyone Piano on Linux through Wine
Exec=$LAUNCHER
Type=Application
Categories=Audio;Music;Education;
StartupNotify=true
StartupWMClass=everyonepiano.exe
Icon=applications-multimedia
EOF
chmod +x "$DESKTOP_FILE"

if command -v gio >/dev/null 2>&1; then
  gio set "$DESKTOP_FILE" metadata::trusted true >/dev/null 2>&1 || true
fi

echo
echo "Installed successfully."
echo "Launcher: $LAUNCHER"
echo "Desktop entry: $DESKTOP_FILE"
echo "Run with: everyone-piano-linux"

