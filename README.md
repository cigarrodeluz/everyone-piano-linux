# everyone-piano-linux

Run Everyone Piano on Linux through a dedicated Wine prefix.

This repository does not redistribute Everyone Piano or Wine. It provides scripts and documentation to install the official Everyone Piano Windows installer into a Linux-friendly Wine setup.

## Explicacao Simples

Este ZIP nao e o Everyone Piano.

Este ZIP e um ajudante para instalar e abrir o Everyone Piano no Linux do jeito certo pelo Wine.

Voce precisa ter:

- Wine instalado no Linux
- O instalador do Everyone Piano baixado, por exemplo `EveryonePiano2.5.9.4_setup.exe`

Depois de baixar o ZIP deste repositorio:

1. Extraia o ZIP.
2. Abra um terminal dentro da pasta extraida.
3. Rode:

   ```sh
   ./scripts/install.sh ~/Downloads/EveryonePiano2.5.9.4_setup.exe
   ```

4. Depois abra o programa com:

   ```sh
   everyone-piano-linux
   ```

Se voce baixou o Everyone Piano como `.zip`, pode passar o ZIP direto:

```sh
./scripts/install.sh ~/Downloads/EveryonePiano2.5.9.4_setup.zip
```

Se voce ja instalou o Everyone Piano antes e ele esta funcionando, voce nao precisa deste repositorio. Se ele abre e da erro no Wine, use este repositorio para instalar de novo em um Wine separado e configurado para funcionar.

## Links

- Everyone Piano official download page: https://www.everyonepiano.com/download.html
- WineHQ official download page: https://www.winehq.org/download
- Extra link notes: [docs/LINKS.md](docs/LINKS.md)

## What This Does

- Creates an isolated Wine prefix at `~/.local/share/everyone-piano-linux/wineprefix`
- Forces the prefix to 32-bit with `WINEARCH=win32`
- Sets the Wine Windows version to `winxp`
- Installs Everyone Piano silently from your downloaded installer
- Creates a launcher named `everyone-piano-linux`
- Adds a desktop entry to your application menu

The Windows XP setting is intentional. In testing, Everyone Piano started crashing in Wine's newer audio path unless the prefix was set to `winxp`.

## Install

1. Install Wine.

   Use your distro packages or WineHQ:

   https://www.winehq.org/download

   On Debian/Ubuntu-like systems, this repo includes a helper:

   ```sh
   scripts/install-wine-ubuntu.sh --yes
   ```

2. Download Everyone Piano from the official page:

   https://www.everyonepiano.com/download.html

3. Run the installer script:

   ```sh
   scripts/install.sh ~/Downloads/EveryonePiano2.5.9.4_setup.exe
   ```

   ZIP installers are also accepted:

   ```sh
   scripts/install.sh ~/Downloads/EveryonePiano2.5.9.4_setup.zip
   ```

4. Start Everyone Piano:

   ```sh
   everyone-piano-linux
   ```

   Or:

   ```sh
   scripts/run.sh
   ```

## Install From A URL

If you have a direct installer URL:

```sh
scripts/install.sh "https://example.com/EveryonePiano2.5.9.4_setup.exe"
```

Prefer the official Everyone Piano page when possible. Direct mirrors can change or be unavailable by region.

## Diagnose

```sh
scripts/diagnose.sh
```

Expected important lines:

```text
#arch=win32
Version    REG_SZ    winxp
application.name = "EveryonePiano"
```

## Uninstall

```sh
scripts/uninstall.sh --yes
```

## Publish To GitHub

From this repository directory:

```sh
gh auth login
gh repo create everyone-piano-linux --public --source=. --remote=origin --push
```

If you prefer a private repository, replace `--public` with `--private`.

## Tested Setup

- Wine 10.0 on Linux
- Everyone Piano 2.5.9.4
- Dedicated 32-bit Wine prefix
- Windows version: `winxp`
- PipeWire/PulseAudio audio output

## Legal

Everyone Piano is owned by its publisher. Wine is developed by the Wine project. This repository only contains launcher scripts and documentation.
