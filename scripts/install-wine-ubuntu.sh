#!/usr/bin/env sh
set -eu

cat <<'EOF'
This helper installs Wine from your distro packages on Debian/Ubuntu-like systems.

Official WineHQ download/install page:
  https://www.winehq.org/download

This command will use sudo and apt. Re-run with --yes to continue.
EOF

if [ "${1:-}" != "--yes" ]; then
  exit 2
fi

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y --install-recommends wine wine32 wine64 winetricks

wine --version

