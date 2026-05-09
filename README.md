# everyone-piano-linux

Run Everyone Piano on Linux through a dedicated Wine prefix.

This repository does not redistribute Everyone Piano or Wine. It only provides scripts and documentation that install the official Everyone Piano Windows installer into a Wine setup that works reliably on Linux.

## Simple Explanation

This ZIP is not Everyone Piano.

This ZIP is a helper that installs and launches Everyone Piano on Linux through Wine with the correct compatibility settings.

You need:

- Wine installed on Linux
- The Everyone Piano installer downloaded, for example `EveryonePiano2.5.9.4_setup.exe`

After downloading this repository as a ZIP:

1. Extract the ZIP.
2. Open a terminal inside the extracted folder.
3. Run:

   ```sh
   ./scripts/install.sh ~/Downloads/EveryonePiano2.5.9.4_setup.exe
   ```

4. Start Everyone Piano with:

   ```sh
   everyone-piano-linux
   ```

If your Everyone Piano download is a `.zip` file, you can pass the ZIP directly:

```sh
./scripts/install.sh ~/Downloads/EveryonePiano2.5.9.4_setup.zip
```

If Everyone Piano is already installed and working, you do not need this repository. If it opens and crashes under Wine, use this repository to reinstall it in a separate Wine prefix configured for compatibility.

## What Happens When You Run The Command

When you run:

```sh
./scripts/install.sh ~/Downloads/EveryonePiano2.5.9.4_setup.exe
```

the script automatically:

1. Checks whether Wine is installed.
2. Creates a separate Wine installation area only for Everyone Piano:

   ```text
   ~/.local/share/everyone-piano-linux/wineprefix
   ```

3. Configures that Wine prefix as 32-bit.
4. Sets Wine to behave like Windows XP, which avoids the startup crash seen with newer Wine audio paths.
5. Runs the Everyone Piano installer silently.
6. Creates a command named:

   ```sh
   everyone-piano-linux
   ```

7. Creates a desktop launcher in the Linux application menu.

After that, you do not need to open the installer again. To use the piano, run:

```sh
everyone-piano-linux
```

## Official Links

- Everyone Piano official download page: https://www.everyonepiano.com/download.html
- WineHQ official download page: https://www.winehq.org/download
- Extra link notes: [docs/LINKS.md](docs/LINKS.md)

## Install Wine

Use your Linux distribution packages or the official WineHQ instructions:

https://www.winehq.org/download

On Debian/Ubuntu-like systems, this repository also includes a helper:

```sh
./scripts/install-wine-ubuntu.sh --yes
```

## Install Everyone Piano

Download Everyone Piano from the official page:

https://www.everyonepiano.com/download.html

Then run:

```sh
./scripts/install.sh ~/Downloads/EveryonePiano2.5.9.4_setup.exe
```

ZIP installers are also accepted:

```sh
./scripts/install.sh ~/Downloads/EveryonePiano2.5.9.4_setup.zip
```

## Install From A Direct URL

If you have a direct installer URL:

```sh
./scripts/install.sh "https://example.com/EveryonePiano2.5.9.4_setup.exe"
```

Prefer the official Everyone Piano download page when possible. Direct mirrors can change or be unavailable depending on your region.

## Start Everyone Piano

After installation:

```sh
everyone-piano-linux
```

Or from inside this repository:

```sh
./scripts/run.sh
```

## Diagnose Problems

Run:

```sh
./scripts/diagnose.sh
```

Important expected lines:

```text
#arch=win32
Version    REG_SZ    winxp
application.name = "EveryonePiano"
```

If `application.name = "EveryonePiano"` appears under the audio section, Wine created an audio stream for the app.

## Uninstall

```sh
./scripts/uninstall.sh --yes
```

This removes the dedicated Wine prefix, the `everyone-piano-linux` launcher, and the desktop entry created by the installer script.

## Tested Setup

- Wine 10.0 on Linux
- Everyone Piano 2.5.9.4
- Dedicated 32-bit Wine prefix
- Windows version: `winxp`
- PipeWire/PulseAudio audio output

## Publish To GitHub

From this repository directory:

```sh
gh auth login
gh repo create everyone-piano-linux --public --source=. --remote=origin --push
```

If you prefer a private repository, replace `--public` with `--private`.

## Legal

Everyone Piano is owned by its publisher. Wine is developed by the Wine project. This repository only contains launcher scripts and documentation.
