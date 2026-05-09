# Troubleshooting

## The app opens and then Wine shows "Program Error"

Run:

```sh
scripts/diagnose.sh
```

Check that the output says:

```text
#arch=win32
Version    REG_SZ    winxp
```

If the prefix is not 32-bit, remove it and reinstall:

```sh
scripts/uninstall.sh --yes
scripts/install.sh ~/Downloads/EveryonePiano2.5.9.4_setup.exe
```

## Wine is missing

Install Wine from your distro or WineHQ:

https://www.winehq.org/download

On Debian/Ubuntu-like systems you can try:

```sh
scripts/install-wine-ubuntu.sh --yes
```

## No sound

Check whether Everyone Piano created a PulseAudio/PipeWire stream:

```sh
pactl list sink-inputs | grep -E 'Sink Input|application.name|media.name'
```

You should see an entry with:

```text
application.name = "EveryonePiano"
```

If it exists but there is no audible sound, check your system mixer and output device.

## Installer URL does not work

Use the official download page instead of a direct mirror:

https://www.everyonepiano.com/download.html

Then pass the downloaded file to the installer:

```sh
scripts/install.sh ~/Downloads/EveryonePiano2.5.9.4_setup.exe
```

